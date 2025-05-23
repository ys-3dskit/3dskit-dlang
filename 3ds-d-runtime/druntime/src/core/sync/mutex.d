/**
 * The mutex module provides a primitive for maintaining mutually exclusive
 * access.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Sean Kelly
 * Source:    $(DRUNTIMESRC core/sync/_mutex.d)
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sync.mutex;


public import core.sync.exception;

version (Horizon)
{
    import ys3ds.ctru._3ds.synchronization;
}
else
{
    static assert(false, "Platform not supported");
}

////////////////////////////////////////////////////////////////////////////////
// Mutex
//
// void lock();
// void unlock();
// bool tryLock();
////////////////////////////////////////////////////////////////////////////////


/**
 * This class represents a general purpose, recursive mutex.
 *
 * Implemented using `pthread_mutex` on Posix and `CRITICAL_SECTION`
 * on Windows.
 */
class Mutex : Object.Monitor
{
    ////////////////////////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Initializes a mutex object.
     *
     */
    this() @trusted nothrow @nogc
    {
        this(true);
    }

    /// ditto
    this() shared @trusted nothrow @nogc
    {
        this(true);
    }

    // Undocumented, useful only in Mutex.this().
    private this(this Q)(bool _unused_) @trusted nothrow @nogc
        if (is(Q == Mutex) || is(Q == shared Mutex))
    {
        /* static if (UseLightLock)
            LightLock_Init(&m_lock);
        else */
            RecursiveLock_Init(&m_lock);

        m_proxy.link = this;
        this.__monitor = cast(void*) &m_proxy;
    }


    /**
     * Initializes a mutex object and sets it as the monitor for `obj`.
     *
     * In:
     *  `obj` must not already have a monitor.
     */
    this(Object obj) @trusted nothrow @nogc
    {
        this(obj, true);
    }

    /// ditto
    this(Object obj) shared @trusted nothrow @nogc
    {
        this(obj, true);
    }

    // Undocumented, useful only in Mutex.this(Object).
    private this(this Q)(Object obj, bool _unused_) @trusted nothrow @nogc
        if (is(Q == Mutex) || is(Q == shared Mutex))
    in
    {
        assert(obj !is null,
            "The provided object must not be null.");
        assert(obj.__monitor is null,
            "The provided object has a monitor already set!");
    }
    do
    {
        this();
        obj.__monitor = cast(void*) &m_proxy;
    }


    ~this() @trusted nothrow @nogc
    {
        this.__monitor = null;
    }


    ////////////////////////////////////////////////////////////////////////////
    // General Actions
    ////////////////////////////////////////////////////////////////////////////


    /**
     * If this lock is not already held by the caller, the lock is acquired,
     * then the internal counter is incremented by one.
     *
     * Note:
     *    `Mutex.lock` does not throw, but a class derived from Mutex can throw.
     *    Use `lock_nothrow` in `nothrow @nogc` code.
     */
    @trusted void lock()
    {
        lock_nothrow();
    }

    /// ditto
    @trusted void lock() shared
    {
        lock_nothrow();
    }

    /// ditto
    final void lock_nothrow(this Q)() nothrow @trusted @nogc
        if (is(Q == Mutex) || is(Q == shared Mutex))
    {
        /* static if (UseLightLock)
            LightLock_Lock(&m_lock);
        else */
            RecursiveLock_Lock(&m_lock);
    }

    /**
     * Decrements the internal lock count by one.  If this brings the count to
     * zero, the lock is released.
     *
     * Note:
     *    `Mutex.unlock` does not throw, but a class derived from Mutex can throw.
     *    Use `unlock_nothrow` in `nothrow @nogc` code.
     */
    @trusted void unlock()
    {
        unlock_nothrow();
    }

    /// ditto
    @trusted void unlock() shared
    {
        unlock_nothrow();
    }

    /// ditto
    final void unlock_nothrow(this Q)() nothrow @trusted @nogc
        if (is(Q == Mutex) || is(Q == shared Mutex))
    {
        /* static if (UseLightLock)
            LightLock_Unlock(&m_lock);
        else */
            RecursiveLock_Unlock(&m_lock);
    }

    /**
     * If the lock is held by another caller, the method returns.  Otherwise,
     * the lock is acquired if it is not already held, and then the internal
     * counter is incremented by one.
     *
     * Returns:
     *  true if the lock was acquired and false if not.
     *
     * Note:
     *    `Mutex.tryLock` does not throw, but a class derived from Mutex can throw.
     *    Use `tryLock_nothrow` in `nothrow @nogc` code.
     */
    bool tryLock() @trusted
    {
        return tryLock_nothrow();
    }

    /// ditto
    bool tryLock() shared @trusted
    {
        return tryLock_nothrow();
    }

    /// ditto
    final bool tryLock_nothrow(this Q)() nothrow @trusted @nogc
        if (is(Q == Mutex) || is(Q == shared Mutex))
    {
        /* static if (UseLightLock)
            return LightLock_TryLock(&m_lock) == 0;
        else */
            return RecursiveLock_TryLock(&m_lock) == 0;
    }


package:
    /* static if (UseLightLock)
        LightLock m_lock;
    else */
        RecursiveLock m_lock;

    struct MonitorProxy
    {
        Object.Monitor link;
    }

    MonitorProxy            m_proxy;
}

///
/* @safe nothrow -> see druntime PR 1726 */
// Test regular usage.
unittest
{
    import core.thread : Thread;

    class Resource
    {
        Mutex mtx;
        int cargo;

        this() shared @safe nothrow
        {
            mtx = new shared Mutex();
            cargo = 42;
        }

        void useResource() shared @trusted nothrow @nogc
        {
            mtx.lock_nothrow();
            (cast() cargo) += 1;
            mtx.unlock_nothrow();
        }
    }

    shared Resource res = new shared Resource();

    auto otherThread = new Thread(
    {
        foreach (i; 0 .. 10000)
            res.useResource();
    }).start();

    foreach (i; 0 .. 10000)
        res.useResource();

    otherThread.join();

    assert (res.cargo == 20042);
}

// Test @nogc usage.
@system @nogc nothrow unittest
{
    import core.stdc.stdlib : malloc, free;
    import core.lifetime : emplace;

    auto mtx = cast(shared Mutex) malloc(__traits(classInstanceSize, Mutex));
    emplace(mtx);

    mtx.lock_nothrow();

    { // test recursive locking
        mtx.tryLock_nothrow();
        mtx.unlock_nothrow();
    }

    mtx.unlock_nothrow();

    // In general destorying classes like this is not
    // safe, but since we know that the only base class
    // of Mutex is Object and it doesn't have a dtor
    // we can simply call the non-virtual __dtor() here.

    // Ok to cast away shared because destruction
    // should happen only from a single thread.
    (cast(Mutex) mtx).__dtor();

    // Verify that the underlying implementation has been destroyed by checking
    // that locking is not possible. This assumes that the underlying
    // implementation is well behaved and makes the object non-lockable upon
    // destruction. The Bionic, DragonFly, Musl, and Solaris C runtimes don't
    // appear to do so, so skip this test.
    version (CRuntime_Bionic) {} else
    version (CRuntime_Musl) {} else
    version (DragonFlyBSD) {} else
    version (Solaris) {} else
    assert(!mtx.tryLock_nothrow());

    free(cast(void*) mtx);
}

// Test single-thread (non-shared) use.
unittest
{
    Mutex m = new Mutex();

    m.lock();

    m.tryLock();
    m.unlock();

    m.unlock();
}

unittest
{
    import core.thread;

    auto mutex      = new Mutex;
    int  numThreads = 10;
    int  numTries   = 1000;
    int  lockCount  = 0;

    void testFn()
    {
        for (int i = 0; i < numTries; ++i)
        {
            synchronized (mutex)
            {
                ++lockCount;
            }
        }
    }

    auto group = new ThreadGroup;

    for (int i = 0; i < numThreads; ++i)
        group.create(&testFn);

    group.joinAll();
    assert(lockCount == numThreads * numTries);
}
