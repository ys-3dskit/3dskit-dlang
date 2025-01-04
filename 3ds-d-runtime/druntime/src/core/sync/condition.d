/**
 * The condition module provides a primitive for synchronized condition
 * checking.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Sean Kelly
 * Source:    $(DRUNTIMESRC core/sync/_condition.d)
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sync.condition;


public import core.sync.exception;
public import core.sync.mutex;
public import core.time;

import core.exception : AssertError, staticError;

version (Horizon)
{
    import ys3ds.ctru._3ds.synchronization;
    import ys3ds.ctru._3ds.svc : ArbitrationType;
    import ys3ds.ctru._3ds.result : R_DESCRIPTION, RD_TIMEOUT;
}
else
{
    static assert(false, "Platform not supported");
}

// libctru's condvar works, but uses lightlocks, and we want it to use recursivelocks. gah.
// see https://github.com/devkitPro/libctru/blob/30dc651/libctru/source/synchronization.c#L157

private
{
    pragma(inline)
    void _beginWait(CondVar* cv, RecursiveLock* lock)
    {
        int val;
        do
            val = __ldrex(cv) - 1;
        while (__strex(cv, val));

        LightLock_Unlock(lock);
    }

    pragma(inline)
    void _endWait(CondVar* cv, RecursiveLock* lock, int num_threads)
    {
        bool hasWaiters;
        int val;

        do
        {
            val = __ldrex(cv);
            hasWaiters = val < 0;
            if (hasWaiters)
            {
                if (num_threads < 0)
                    val = 0;
                else if (val <= -num_threads)
                    val += num_threads;
                else
                    val = 0;
            }
        }
        while (__strex(cv, val));

        return hasWaiters;
    }

    // init is not necessary as it just sets the cond var to zero and thats default in D anyway.

    void _wait(CondVar* cv, RecursiveLock* lock)
    {
        _beginWait(cv, lock);
        syncArbitrateAddress(cv, ArbitrationType.ARBITRATION_WAIT_IF_LESS_THAN, 0);
        RecursiveLock_Lock(lock);
    }

    int _waitTimeout(CondVar* cv, RecursiveLock* lock, long timeout_ns)
    {
        _beginWait(cv, lock);

        bool timedOut;
        auto rc = syncArbitrateAddressWithTimeout(cv, ArbitrationType.ARBITRATION_WAIT_IF_LESS_THAN_TIMEOUT, 0, timeout_ns);
        if (R_DESCRIPTION(rc) == RD_TIMEOUT)
        {
            timedOut = _endWait(cv, 1);
            __dmb();
        }

        RecursiveLock_Lock(lock);

        return timedOut;
    }

    // condvar_wakeup is fine
}


////////////////////////////////////////////////////////////////////////////////
// Condition
//
// void wait();
// void notify();
// void notifyAll();
////////////////////////////////////////////////////////////////////////////////

/**
 * This class represents a condition variable as conceived by C.A.R. Hoare.  As
 * per Mesa type monitors however, "signal" has been replaced with "notify" to
 * indicate that control is not transferred to the waiter when a notification
 * is sent.
 */
class Condition
{
    ////////////////////////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////////////////////////

    /**
     * Initializes a condition object which is associated with the supplied
     * mutex object.
     *
     * Params:
     *  m = The mutex with which this condition will be associated.
     *
     * Throws:
     *  SyncError on error.
     */
    this( Mutex m ) nothrow @safe @nogc
    {
        this(m, true);
    }

    /// ditto
    this( shared Mutex m ) shared nothrow @safe @nogc
    {
        import core.atomic : atomicLoad;
        this(atomicLoad(m), true);
    }

    //
    private this(this Q, M)( M m, bool _unused_ ) nothrow @trusted @nogc
        if ((is(Q == Condition) && is(M == Mutex)) ||
            (is(Q == shared Condition) && is(M == shared Mutex)))
    {
        import core.atomic;

        static if (is(Q == shared))
            m_assocMutex = atomicLoad(m).m_lock;
        else
            m_assocMutex = m.m_lock;
    }


    ////////////////////////////////////////////////////////////////////////////
    // General Properties
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Gets the mutex associated with this condition.
     *
     * Returns:
     *  The mutex associated with this condition.
     */
    @property Mutex mutex()
    {
        return m_assocMutex;
    }

    /// ditto
    @property shared(Mutex) mutex() shared
    {
        import core.atomic : atomicLoad;
        return atomicLoad(m_assocMutex);
    }

    // undocumented function for internal use
    final @property Mutex mutex_nothrow() pure nothrow @safe @nogc
    {
        return m_assocMutex;
    }

    // ditto
    final @property shared(Mutex) mutex_nothrow() shared pure nothrow @safe @nogc
    {
        import core.atomic : atomicLoad;
        return atomicLoad(m_assocMutex);
    }

    ////////////////////////////////////////////////////////////////////////////
    // General Actions
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Wait until notified.
     *
     * Throws:
     *  SyncError on error.
     */
    void wait()
    {
        wait!(typeof(this))(true);
    }

    /// ditto
    void wait() shared
    {
        wait!(typeof(this))(true);
    }

    /// ditto
    void wait(this Q)( bool _unused_ )
        if (is(Q == Condition) || is(Q == shared Condition))
    {
        _wait(&m_cndvar, &m_assocMutex);
    }

    /**
     * Suspends the calling thread until a notification occurs or until the
     * supplied time period has elapsed.
     *
     * Params:
     *  val = The time to wait.
     *
     * In:
     *  val must be non-negative.
     *
     * Throws:
     *  SyncError on error.
     *
     * Returns:
     *  true if notified before the timeout and false if not.
     */
    bool wait( Duration val )
    {
        return wait!(typeof(this))(val, true);
    }

    /// ditto
    bool wait( Duration val ) shared
    {
        return wait!(typeof(this))(val, true);
    }

    /// ditto
    bool wait(this Q)( Duration val, bool _unused_ )
        if (is(Q == Condition) || is(Q == shared Condition))
    in
    {
        assert( !val.isNegative );
    }
    do
    {
        return _waitTimeout(&m_cndvar, &m_assocMutex, val.total!"nsecs");
    }

    /**
     * Notifies one waiter.
     *
     * Throws:
     *  SyncError on error.
     */
    void notify()
    {
        notify!(typeof(this))(true);
    }

    /// ditto
    void notify() shared
    {
        notify!(typeof(this))(true);
    }

    /// ditto
    void notify(this Q)( bool _unused_ )
        if (is(Q == Condition) || is(Q == shared Condition))
    {
        CondVar_Signal(&m_cndvar);
    }

    /**
     * Notifies all waiters.
     *
     * Throws:
     *  SyncError on error.
     */
    void notifyAll()
    {
        notifyAll!(typeof(this))(true);
    }

    /// ditto
    void notifyAll() shared
    {
        notifyAll!(typeof(this))(true);
    }

    /// ditto
    void notifyAll(this Q)( bool _unused_ )
        if (is(Q == Condition) || is(Q == shared Condition))
    {
        CondVar_Broadcast(&m_cndvar);
    }

private:

    CondVar m_cndvar;
    RecursiveLock m_assocMutex;
}


////////////////////////////////////////////////////////////////////////////////
// Unit Tests
////////////////////////////////////////////////////////////////////////////////

unittest
{
    import core.thread;
    import core.sync.mutex;
    import core.sync.semaphore;


    void testNotify()
    {
        auto mutex      = new Mutex;
        auto condReady  = new Condition( mutex );
        auto semDone    = new Semaphore;
        auto synLoop    = new Object;
        int  numWaiters = 10;
        int  numTries   = 10;
        int  numReady   = 0;
        int  numTotal   = 0;
        int  numDone    = 0;
        int  numPost    = 0;

        void waiter()
        {
            for ( int i = 0; i < numTries; ++i )
            {
                synchronized( mutex )
                {
                    while ( numReady < 1 )
                    {
                        condReady.wait();
                    }
                    --numReady;
                    ++numTotal;
                }

                synchronized( synLoop )
                {
                    ++numDone;
                }
                semDone.wait();
            }
        }

        auto group = new ThreadGroup;

        for ( int i = 0; i < numWaiters; ++i )
            group.create( &waiter );

        for ( int i = 0; i < numTries; ++i )
        {
            for ( int j = 0; j < numWaiters; ++j )
            {
                synchronized( mutex )
                {
                    ++numReady;
                    condReady.notify();
                }
            }
            while ( true )
            {
                synchronized( synLoop )
                {
                    if ( numDone >= numWaiters )
                        break;
                }
                Thread.yield();
            }
            for ( int j = 0; j < numWaiters; ++j )
            {
                semDone.notify();
            }
        }

        group.joinAll();
        assert( numTotal == numWaiters * numTries );
    }


    void testNotifyAll()
    {
        auto mutex      = new Mutex;
        auto condReady  = new Condition( mutex );
        int  numWaiters = 10;
        int  numReady   = 0;
        int  numDone    = 0;
        bool alert      = false;

        void waiter()
        {
            synchronized( mutex )
            {
                ++numReady;
                while ( !alert )
                    condReady.wait();
                ++numDone;
            }
        }

        auto group = new ThreadGroup;

        for ( int i = 0; i < numWaiters; ++i )
            group.create( &waiter );

        while ( true )
        {
            synchronized( mutex )
            {
                if ( numReady >= numWaiters )
                {
                    alert = true;
                    condReady.notifyAll();
                    break;
                }
            }
            Thread.yield();
        }
        group.joinAll();
        assert( numReady == numWaiters && numDone == numWaiters );
    }


    void testWaitTimeout()
    {
        auto mutex      = new Mutex;
        auto condReady  = new Condition( mutex );
        bool waiting    = false;
        bool alertedOne = true;
        bool alertedTwo = true;

        void waiter()
        {
            synchronized( mutex )
            {
                waiting    = true;
                // we never want to miss the notification (30s)
                alertedOne = condReady.wait( dur!"seconds"(30) );
                // but we don't want to wait long for the timeout (10ms)
                alertedTwo = condReady.wait( dur!"msecs"(10) );
            }
        }

        auto thread = new Thread( &waiter );
        thread.start();

        while ( true )
        {
            synchronized( mutex )
            {
                if ( waiting )
                {
                    condReady.notify();
                    break;
                }
            }
            Thread.yield();
        }
        thread.join();
        assert( waiting );
        assert( alertedOne );
        assert( !alertedTwo );
    }

    testNotify();
    testNotifyAll();
    testWaitTimeout();
}

unittest
{
    import core.thread;
    import core.sync.mutex;
    import core.sync.semaphore;


    void testNotify()
    {
        auto mutex      = new shared Mutex;
        auto condReady  = new shared Condition( mutex );
        auto semDone    = new Semaphore;
        auto synLoop    = new Object;
        int  numWaiters = 10;
        int  numTries   = 10;
        int  numReady   = 0;
        int  numTotal   = 0;
        int  numDone    = 0;
        int  numPost    = 0;

        void waiter()
        {
            for ( int i = 0; i < numTries; ++i )
            {
                synchronized( mutex )
                {
                    while ( numReady < 1 )
                    {
                        condReady.wait();
                    }
                    --numReady;
                    ++numTotal;
                }

                synchronized( synLoop )
                {
                    ++numDone;
                }
                semDone.wait();
            }
        }

        auto group = new ThreadGroup;

        for ( int i = 0; i < numWaiters; ++i )
            group.create( &waiter );

        for ( int i = 0; i < numTries; ++i )
        {
            for ( int j = 0; j < numWaiters; ++j )
            {
                synchronized( mutex )
                {
                    ++numReady;
                    condReady.notify();
                }
            }
            while ( true )
            {
                synchronized( synLoop )
                {
                    if ( numDone >= numWaiters )
                        break;
                }
                Thread.yield();
            }
            for ( int j = 0; j < numWaiters; ++j )
            {
                semDone.notify();
            }
        }

        group.joinAll();
        assert( numTotal == numWaiters * numTries );
    }


    void testNotifyAll()
    {
        auto mutex      = new shared Mutex;
        auto condReady  = new shared Condition( mutex );
        int  numWaiters = 10;
        int  numReady   = 0;
        int  numDone    = 0;
        bool alert      = false;

        void waiter()
        {
            synchronized( mutex )
            {
                ++numReady;
                while ( !alert )
                    condReady.wait();
                ++numDone;
            }
        }

        auto group = new ThreadGroup;

        for ( int i = 0; i < numWaiters; ++i )
            group.create( &waiter );

        while ( true )
        {
            synchronized( mutex )
            {
                if ( numReady >= numWaiters )
                {
                    alert = true;
                    condReady.notifyAll();
                    break;
                }
            }
            Thread.yield();
        }
        group.joinAll();
        assert( numReady == numWaiters && numDone == numWaiters );
    }


    void testWaitTimeout()
    {
        auto mutex      = new shared Mutex;
        auto condReady  = new shared Condition( mutex );
        bool waiting    = false;
        bool alertedOne = true;
        bool alertedTwo = true;

        void waiter()
        {
            synchronized( mutex )
            {
                waiting    = true;
                // we never want to miss the notification (30s)
                alertedOne = condReady.wait( dur!"seconds"(30) );
                // but we don't want to wait long for the timeout (10ms)
                alertedTwo = condReady.wait( dur!"msecs"(10) );
            }
        }

        auto thread = new Thread( &waiter );
        thread.start();

        while ( true )
        {
            synchronized( mutex )
            {
                if ( waiting )
                {
                    condReady.notify();
                    break;
                }
            }
            Thread.yield();
        }
        thread.join();
        assert( waiting );
        assert( alertedOne );
        assert( !alertedTwo );
    }

    testNotify();
    testNotifyAll();
    testWaitTimeout();
}
