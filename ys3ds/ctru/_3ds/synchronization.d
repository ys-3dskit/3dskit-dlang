/**
 * @file synchronization.h
 * @brief Provides synchronization locks.
 */

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.svc;

extern (C):

/// A light lock.
alias LightLock = int;

struct __lock_t {
  // ref: https://rust3ds.github.io/ctru-rs/crates/ctru_sys/struct.__lock_t.html
  LightLock lock;
  uint thread_tag;
  uint counter;
}

/// A recursive lock.
alias RecursiveLock = __lock_t;

/// A condition variable.
alias CondVar = int;

/// A light event.
struct LightEvent
{
    int state; ///< State of the event: -2=cleared sticky, -1=cleared oneshot, 0=signaled oneshot, 1=signaled sticky
    LightLock lock; ///< Lock used for sticky timer operation
}

/// A light semaphore.
struct LightSemaphore
{
    int current_count; ///< The current release count of the semaphore
    short num_threads_acq; ///< Number of threads concurrently acquiring the semaphore
    short max_count; ///< The maximum release count of the semaphore
}

// TODO: test that all inline assembly produces identical output to C headers

/// Performs a Data Synchronization Barrier operation.
void __dsb ()
{
  asm
  {
    mcr p15, 0, 0, c7, c10, 4;
  }
}

/// Performs a Data Memory Barrier operation.
void __dmb ()
{
  asm
  {
    mcr p15, 0, 0, c7, c10, 5;
  }
}

/// Performs an Instruction Synchronization Barrier (officially "flush prefetch buffer") operation.
void __isb ()
{
  asm
  {
    mcr p15, 0, 0, c7, c5, 4;
  }
}

/// Performs a clrex operation.
void __clrex ()
{
  asm
  {
    clrex;
  }
}

/**
 * @brief Performs a ldrex operation.
 * @param addr Address to perform the operation on.
 * @return The resulting value.
 */
int __ldrex (int* addr)
{
  int val;
  asm
  {
    ldrex val, addr;
  }
  return val;
}

/**
 * @brief Performs a strex operation.
 * @param addr Address to perform the operation on.
 * @param val Value to store.
 * @return Whether the operation was successful.
 */
bool __strex (int* addr, int val)
{
  bool res;
  asm
  {
    strex res, val, addr;
  }
  return res;
}

/**
 * @brief Performs a ldrexh operation.
 * @param addr Address to perform the operation on.
 * @return The resulting value.
 */
ushort __ldrexh (ushort* addr)
{
  ushort val;
  asm
  {
    ldrexh val, addr;
  }
  return val;
}

/**
 * @brief Performs a strexh operation.
 * @param addr Address to perform the operation on.
 * @param val Value to store.
 * @return Whether the operation was successful.
 */
bool __strexh (ushort* addr, ushort val)
{
  bool res;
  asm
  {
    strexh res, val, addr;
  }
  return res;
}

/**
 * @brief Performs a ldrexb operation.
 * @param addr Address to perform the operation on.
 * @return The resulting value.
 */
ubyte __ldrexb (ubyte* addr)
{
  ubyte val;
  asm
  {
    ldrexb val, addr;
  }
  return val;
}

/**
 * @brief Performs a strexb operation.
 * @param addr Address to perform the operation on.
 * @param val Value to store.
 * @return Whether the operation was successful.
 */
bool __strexb (ubyte* addr, ubyte val)
{
  bool res;
  asm
  {
    strexb res, val, addr;
  }
  return res;
}

/// Performs an atomic pre-increment operation.
extern (D) auto AtomicIncrement(T)(auto ref T ptr)
{
    return __atomic_add_fetch(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic pre-decrement operation.
extern (D) auto AtomicDecrement(T)(auto ref T ptr)
{
    return __atomic_sub_fetch(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic post-increment operation.
extern (D) auto AtomicPostIncrement(T)(auto ref T ptr)
{
    return __atomic_fetch_add(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic post-decrement operation.
extern (D) auto AtomicPostDecrement(T)(auto ref T ptr)
{
    return __atomic_fetch_sub(cast(uint*) ptr, 1, __ATOMIC_SEQ_CST);
}

/// Performs an atomic swap operation.
extern (D) auto AtomicSwap(T0, T1)(auto ref T0 ptr, auto ref T1 value)
{
    return __atomic_exchange_n(cast(uint*) ptr, value, __ATOMIC_SEQ_CST);
}

/**
 * @brief Function used to implement user-mode synchronization primitives.
 * @param addr Pointer to a signed 32-bit value whose address will be used to identify waiting threads.
 * @param type Type of action to be performed by the arbiter
 * @param value Number of threads to signal if using @ref ARBITRATION_SIGNAL, or the value used for comparison.
 *
 * This will perform an arbitration based on #type. The comparisons are done between #value and the value at the address #addr.
 *
 * @code
 * s32 val=0;
 * // Does *nothing* since val >= 0
 * syncArbitrateAddress(&val,ARBITRATION_WAIT_IF_LESS_THAN,0);
 * @endcode
 *
 * @note Usage of this function entails an implicit Data Memory Barrier (dmb).
 */
Result syncArbitrateAddress (int* addr, ArbitrationType type, int value);

/**
 * @brief Function used to implement user-mode synchronization primitives (with timeout).
 * @param addr Pointer to a signed 32-bit value whose address will be used to identify waiting threads.
 * @param type Type of action to be performed by the arbiter (must use \ref ARBITRATION_WAIT_IF_LESS_THAN_TIMEOUT or \ref ARBITRATION_DECREMENT_AND_WAIT_IF_LESS_THAN_TIMEOUT)
 * @param value Number of threads to signal if using @ref ARBITRATION_SIGNAL, or the value used for comparison.
 *
 * This will perform an arbitration based on #type. The comparisons are done between #value and the value at the address #addr.
 *
 * @code
 * s32 val=0;
 * // Thread will wait for a signal or wake up after 10000000 nanoseconds because val < 1.
 * syncArbitrateAddressWithTimeout(&val,ARBITRATION_WAIT_IF_LESS_THAN_TIMEOUT,1,10000000LL);
 * @endcode
 *
 * @note Usage of this function entails an implicit Data Memory Barrier (dmb).
 */
Result syncArbitrateAddressWithTimeout (int* addr, ArbitrationType type, int value, long timeout_ns);

/**
 * @brief Initializes a light lock.
 * @param lock Pointer to the lock.
 */
void LightLock_Init (LightLock* lock);

/**
 * @brief Locks a light lock.
 * @param lock Pointer to the lock.
 */
void LightLock_Lock (LightLock* lock);

/**
 * @brief Attempts to lock a light lock.
 * @param lock Pointer to the lock.
 * @return Zero on success, non-zero on failure.
 */
int LightLock_TryLock (LightLock* lock);

/**
 * @brief Unlocks a light lock.
 * @param lock Pointer to the lock.
 */
void LightLock_Unlock (LightLock* lock);

/**
 * @brief Initializes a recursive lock.
 * @param lock Pointer to the lock.
 */
void RecursiveLock_Init (RecursiveLock* lock);

/**
 * @brief Locks a recursive lock.
 * @param lock Pointer to the lock.
 */
void RecursiveLock_Lock (RecursiveLock* lock);

/**
 * @brief Attempts to lock a recursive lock.
 * @param lock Pointer to the lock.
 * @return Zero on success, non-zero on failure.
 */
int RecursiveLock_TryLock (RecursiveLock* lock);

/**
 * @brief Unlocks a recursive lock.
 * @param lock Pointer to the lock.
 */
void RecursiveLock_Unlock (RecursiveLock* lock);

/**
 * @brief Initializes a condition variable.
 * @param cv Pointer to the condition variable.
 */
void CondVar_Init (CondVar* cv);

/**
 * @brief Waits on a condition variable.
 * @param cv Pointer to the condition variable.
 * @param lock Pointer to the lock to atomically unlock/relock during the wait.
 */
void CondVar_Wait (CondVar* cv, LightLock* lock);

/**
 * @brief Waits on a condition variable with a timeout.
 * @param cv Pointer to the condition variable.
 * @param lock Pointer to the lock to atomically unlock/relock during the wait.
 * @param timeout_ns Timeout in nanoseconds.
 * @return Zero on success, non-zero on failure.
 */
int CondVar_WaitTimeout (CondVar* cv, LightLock* lock, long timeout_ns);

/**
 * @brief Wakes up threads waiting on a condition variable.
 * @param cv Pointer to the condition variable.
 * @param num_threads Maximum number of threads to wake up (or \ref ARBITRATION_SIGNAL_ALL to wake them all).
 */
void CondVar_WakeUp (CondVar* cv, int num_threads);

/**
 * @brief Wakes up a single thread waiting on a condition variable.
 * @param cv Pointer to the condition variable.
 */
void CondVar_Signal (CondVar* cv)
{
  CondVar_WakeUp(cv, 1);
}

/**
 * @brief Wakes up all threads waiting on a condition variable.
 * @param cv Pointer to the condition variable.
 */
void CondVar_Broadcast (CondVar* cv)
{
  CondVar_WakeUp(cv, ARBITRATION_SIGNAL_ALL);
}

/**
 * @brief Initializes a light event.
 * @param event Pointer to the event.
 * @param reset_type Type of reset the event uses (RESET_ONESHOT/RESET_STICKY).
 */
void LightEvent_Init (LightEvent* event, ResetType reset_type);

/**
 * @brief Clears a light event.
 * @param event Pointer to the event.
 */
void LightEvent_Clear (LightEvent* event);

/**
 * @brief Wakes up threads waiting on a sticky light event without signaling it. If the event had been signaled before, it is cleared instead.
 * @param event Pointer to the event.
 */
void LightEvent_Pulse (LightEvent* event);

/**
 * @brief Signals a light event, waking up threads waiting on it.
 * @param event Pointer to the event.
 */
void LightEvent_Signal (LightEvent* event);

/**
 * @brief Attempts to wait on a light event.
 * @param event Pointer to the event.
 * @return Non-zero if the event was signaled, zero otherwise.
 */
int LightEvent_TryWait (LightEvent* event);

/**
 * @brief Waits on a light event.
 * @param event Pointer to the event.
 */
void LightEvent_Wait (LightEvent* event);

/**
 * @brief Waits on a light event until either the event is signaled or the timeout is reached.
 * @param event Pointer to the event.
 * @param timeout_ns Timeout in nanoseconds.
 * @return Non-zero on timeout, zero otherwise.
 */
int LightEvent_WaitTimeout (LightEvent* event, long timeout_ns);

/**
 * @brief Initializes a light semaphore.
 * @param event Pointer to the semaphore.
 * @param max_count Initial count of the semaphore.
 * @param max_count Maximum count of the semaphore.
 */
void LightSemaphore_Init (LightSemaphore* semaphore, short initial_count, short max_count);

/**
 * @brief Acquires a light semaphore.
 * @param semaphore Pointer to the semaphore.
 * @param count Acquire count
 */
void LightSemaphore_Acquire (LightSemaphore* semaphore, int count);

/**
 * @brief Attempts to acquire a light semaphore.
 * @param semaphore Pointer to the semaphore.
 * @param count Acquire count
 * @return Zero on success, non-zero on failure
 */
int LightSemaphore_TryAcquire (LightSemaphore* semaphore, int count);

/**
 * @brief Releases a light semaphore.
 * @param semaphore Pointer to the semaphore.
 * @param count Release count
 */
void LightSemaphore_Release (LightSemaphore* semaphore, int count);
