/**
 * @file thread.h
 * @brief Provides functions to use threads.
 */

//import core.stdc.stddef;

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.errf;
import ys3ds.ctru._3ds.svc;
import ys3ds.ctru._3ds.synchronization;

extern (C) @nogc nothrow:

/// Makes the exception handler reuse the stack of the faulting thread as-is
enum RUN_HANDLER_ON_FAULTING_STACK = cast(void*) 1;

/// Makes the exception handler push the exception data on its stack
enum WRITE_DATA_TO_HANDLER_STACK = null;

/// Makes the exception handler push the exception data on the stack of the faulting thread
enum WRITE_DATA_TO_FAULTING_STACK = cast(ERRF_ExceptionData*) 1;

/// libctru thread handle type
// see internal.h
struct Thread_tag;
private struct Thread_tag_partial
{
  //import core.stdc.stdio : _reent; // i have not yet bound _reent so it is opaque.
  // TODO: just make thread_tag have this body once it is correctly sized.

  Handle handle;
  ThreadFunc ep;
  void* arg;
  int rc;
  bool detached, finished;
  /* _reent reent;
  void* stacktop; */
}
alias Thread = Thread_tag*;

pragma(inline, true)
extern (D) ref Handle _thread_tag_get_handle_jank(Thread t) => (cast(Thread_tag_partial*) t).handle;

pragma(inline, true)
extern (D) ref bool _thread_tag_get_finished_jank(Thread t) => (cast(Thread_tag_partial*) t).finished;

/// Exception handler type, necessarily an ARM function that does not return.
alias ExceptionHandler = void function (ERRF_ExceptionInfo* excep, CpuRegisters* regs);

/**
 * @brief Creates a new libctru thread.
 * @param entrypoint The function that will be called first upon thread creation
 * @param arg The argument passed to @p entrypoint
 * @param stack_size The size of the stack that will be allocated for the thread (will be rounded to a multiple of 8 bytes)
 * @param prio Low values gives the thread higher priority.
 *             For userland apps, this has to be within the range [0x18;0x3F].
 *             The main thread usually has a priority of 0x30, but not always. Use svcGetThreadPriority() if you need
 *             to create a thread with a priority that is explicitly greater or smaller than that of the main thread.
 * @param core_id The ID of the processor the thread should be ran on. Processor IDs are labeled starting from 0.
 *                On Old3DS it must be <2, and on New3DS it must be <4.
 *                Pass -1 to execute the thread on all CPUs and -2 to execute the thread on the default CPU (read from the Exheader).
 * @param detached When set to true, the thread is automatically freed when it finishes.
 * @return The libctru thread handle on success, NULL on failure.
 *
 * - Processor #0 is the application core. It is always possible to create a thread on this core.
 * - Processor #1 is the system core. If APT_SetAppCpuTimeLimit is used, it is possible to create a single thread on this core.
 * - Processor #2 is New3DS exclusive. Normal applications can create threads on this core if the exheader kernel flags bitmask has 0x2000 set.
 * - Processor #3 is New3DS exclusive. Normal applications cannot create threads on this core.
 * - Processes in the BASE memory region can always create threads on processors #2 and #3.
 *
 * @note Default exit code of a thread is 0.
 * @warning @ref svcExitThread should never be called from the thread, use @ref threadExit instead.
 */
Thread threadCreate (ThreadFunc entrypoint, void* arg, size_t stack_size, int prio, int core_id, bool detached);

/**
 * @brief Retrieves the OS thread handle of a libctru thread.
 * @param thread libctru thread handle
 * @return OS thread handle
 */
Handle threadGetHandle (Thread thread);

/**
 * @brief Retrieves the exit code of a finished libctru thread.
 * @param thread libctru thread handle
 * @return Exit code
 */
int threadGetExitCode (Thread thread);

/**
 * @brief Frees a finished libctru thread.
 * @param thread libctru thread handle
 * @remarks This function should not be called if the thread is detached, as it is freed automatically when it finishes.
 */
void threadFree (Thread thread);

/**
 * @brief Waits for a libctru thread to finish (or returns immediately if it is already finished).
 * @param thread libctru thread handle
 * @param timeout_ns Timeout in nanoseconds. Pass U64_MAX if a timeout isn't desired
 */
Result threadJoin (Thread thread, ulong timeout_ns);

/**
 *  @brief Changes a thread's status from attached to detached.
 *  @param thread libctru thread handle
 */
void threadDetach (Thread thread);

/**
 * @brief Retrieves the libctru thread handle of the current thread.
 * @return libctru thread handle of the current thread, or NULL for the main thread
 */
Thread threadGetCurrent ();

/**
 * @brief Exits the current libctru thread with an exit code (not usable from the main thread).
 * @param rc Exit code
 */
void threadExit (int rc);

/**
 * @brief Sets the exception handler for the current thread. Called from the main thread, this sets the default handler.
 * @param handler The exception handler, necessarily an ARM function that does not return
 * @param stack_top A pointer to the top of the stack that will be used by the handler. See also @ref RUN_HANDLER_ON_FAULTING_STACK
 * @param exception_data A pointer to the buffer that will contain the exception data.
                         See also @ref WRITE_DATA_TO_HANDLER_STACK and @ref WRITE_DATA_TO_FAULTING_STACK
 *
 * To have CPU exceptions reported through this mechanism, it is normally necessary that UNITINFO is set to a non-zero value when Kernel11 starts,
 * and this mechanism is also controlled by @ref svcKernelSetState type 6, see 3dbrew.
 *
 * VFP exceptions are always reported this way even if the process is being debugged using the debug SVCs.
 *
 * The current thread need not be a libctru thread.
 */
extern(D) void threadOnException (
    ExceptionHandler handler,
    void* stack_top,
    ERRF_ExceptionData* exception_data)
{
  ubyte* tls = cast(ubyte*) getThreadLocalStorage();

  *cast(uint*)(tls + 0x40) = cast(uint) handler;
  *cast(uint*)(tls + 0x44) = cast(uint) stack_top;
  *cast(uint*)(tls + 0x48) = cast(uint) exception_data;

  __dsb();
  __isb();
}
