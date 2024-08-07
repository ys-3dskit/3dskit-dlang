/**
 * @file svc.h
 * @brief Syscall wrappers.
 */

import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

/// Pseudo handle for the current process
enum CUR_PROCESS_HANDLE = 0xFFFF8001;

///@name Memory management
///@{

/**
 * @brief @ref svcControlMemory operation flags
 *
 * The lowest 8 bits are the operation
 */
enum MemOp
{
    MEMOP_FREE = 1, ///< Memory un-mapping
    MEMOP_RESERVE = 2, ///< Reserve memory
    MEMOP_ALLOC = 3, ///< Memory mapping
    MEMOP_MAP = 4, ///< Mirror mapping
    MEMOP_UNMAP = 5, ///< Mirror unmapping
    MEMOP_PROT = 6, ///< Change protection

    MEMOP_REGION_APP = 0x100, ///< APPLICATION memory region.
    MEMOP_REGION_SYSTEM = 0x200, ///< SYSTEM memory region.
    MEMOP_REGION_BASE = 0x300, ///< BASE memory region.

    MEMOP_OP_MASK = 0xFF, ///< Operation bitmask.
    MEMOP_REGION_MASK = 0xF00, ///< Region bitmask.
    MEMOP_LINEAR_FLAG = 0x10000, ///< Flag for linear memory operations

    MEMOP_ALLOC_LINEAR = MEMOP_LINEAR_FLAG | MEMOP_ALLOC ///< Allocates linear memory.
}

/// The state of a memory block.
enum MemState
{
    MEMSTATE_FREE = 0, ///< Free memory
    MEMSTATE_RESERVED = 1, ///< Reserved memory
    MEMSTATE_IO = 2, ///< I/O memory
    MEMSTATE_STATIC = 3, ///< Static memory
    MEMSTATE_CODE = 4, ///< Code memory
    MEMSTATE_PRIVATE = 5, ///< Private memory
    MEMSTATE_SHARED = 6, ///< Shared memory
    MEMSTATE_CONTINUOUS = 7, ///< Continuous memory
    MEMSTATE_ALIASED = 8, ///< Aliased memory
    MEMSTATE_ALIAS = 9, ///< Alias memory
    MEMSTATE_ALIASCODE = 10, ///< Aliased code memory
    MEMSTATE_LOCKED = 11 ///< Locked memory
}

/// Memory permission flags
enum MemPerm
{
    MEMPERM_READ = 1, ///< Readable
    MEMPERM_WRITE = 2, ///< Writable
    MEMPERM_EXECUTE = 4, ///< Executable
    MEMPERM_READWRITE = MEMPERM_READ | MEMPERM_WRITE, ///< Readable and writable
    MEMPERM_READEXECUTE = MEMPERM_READ | MEMPERM_EXECUTE, ///< Readable and executable
    MEMPERM_DONTCARE = 0x10000000 ///< Don't care
}

/// Memory regions.
enum MemRegion
{
    MEMREGION_ALL = 0, ///< All regions.
    MEMREGION_APPLICATION = 1, ///< APPLICATION memory.
    MEMREGION_SYSTEM = 2, ///< SYSTEM memory.
    MEMREGION_BASE = 3 ///< BASE memory.
}

/// Memory information.
struct MemInfo
{
    uint base_addr; ///< Base address.
    uint size; ///< Size.
    uint perm; ///< Memory permissions. See @ref MemPerm
    uint state; ///< Memory state. See @ref MemState
}

/// Memory page information.
struct PageInfo
{
    uint flags; ///< Page flags.
}

/// Arbitration modes.
enum ArbitrationType
{
    ARBITRATION_SIGNAL = 0, ///< Signal #value threads for wake-up.
    ARBITRATION_WAIT_IF_LESS_THAN = 1, ///< If the memory at the address is strictly lower than #value, then wait for signal.
    ARBITRATION_DECREMENT_AND_WAIT_IF_LESS_THAN = 2, ///< If the memory at the address is strictly lower than #value, then decrement it and wait for signal.
    ARBITRATION_WAIT_IF_LESS_THAN_TIMEOUT = 3, ///< If the memory at the address is strictly lower than #value, then wait for signal or timeout.
    ARBITRATION_DECREMENT_AND_WAIT_IF_LESS_THAN_TIMEOUT = 4 ///< If the memory at the address is strictly lower than #value, then decrement it and wait for signal or timeout.
}

/// Special value to signal all the threads
enum ARBITRATION_SIGNAL_ALL = -1;

///@}

///@name Multithreading
///@{

/// Reset types (for use with events and timers)
enum ResetType
{
    RESET_ONESHOT = 0, ///< When the primitive is signaled, it will wake up exactly one thread and will clear itself automatically.
    RESET_STICKY = 1, ///< When the primitive is signaled, it will wake up all threads and it won't clear itself automatically.
    RESET_PULSE = 2 ///< Only meaningful for timers: same as ONESHOT but it will periodically signal the timer instead of just once.
}

/// Types of thread info.
enum ThreadInfoType
{
    THREADINFO_TYPE_UNKNOWN = 0 ///< Unknown.
}

/// Types of resource limit
enum ResourceLimitType
{
    RESLIMIT_PRIORITY = 0, ///< Thread priority
    RESLIMIT_COMMIT = 1, ///< Quantity of allocatable memory
    RESLIMIT_THREAD = 2, ///< Number of threads
    RESLIMIT_EVENT = 3, ///< Number of events
    RESLIMIT_MUTEX = 4, ///< Number of mutexes
    RESLIMIT_SEMAPHORE = 5, ///< Number of semaphores
    RESLIMIT_TIMER = 6, ///< Number of timers
    RESLIMIT_SHAREDMEMORY = 7, ///< Number of shared memory objects, see @ref svcCreateMemoryBlock
    RESLIMIT_ADDRESSARBITER = 8, ///< Number of address arbiters
    RESLIMIT_CPUTIME = 9, ///< CPU time. Value expressed in percentage regular until it reaches 90.

    RESLIMIT_BIT = BIT(31) ///< Forces enum size to be 32 bits
}

/// Pseudo handle for the current thread
enum CUR_THREAD_HANDLE = 0xFFFF8000;

///@}

///@name Device drivers
///@{

/// DMA transfer state.
enum DmaState
{
    DMASTATE_STARTING = 0, ///< DMA transfer involving at least one device is starting and has not reached DMAWFP yet.
    DMASTATE_WFP_DST = 1, ///< DMA channel is in WFP state for the destination device (2nd loop iteration onwards).
    DMASTATE_WFP_SRC = 2, ///< DMA channel is in WFP state for the source device (2nd loop iteration onwards).
    DMASTATE_RUNNING = 3, ///< DMA transfer is running.
    DMASTATE_DONE = 4 ///< DMA transfer is done.
}

/// Configuration flags for \ref DmaConfig.
enum
{
    DMACFG_SRC_IS_DEVICE = BIT(0), ///< DMA source is a device/peripheral. Address will not auto-increment.
    DMACFG_DST_IS_DEVICE = BIT(1), ///< DMA destination is a device/peripheral. Address will not auto-increment.
    DMACFG_WAIT_AVAILABLE = BIT(2), ///< Make \ref svcStartInterProcessDma wait for the channel to be unlocked.
    DMACFG_KEEP_LOCKED = BIT(3), ///< Keep the channel locked after the transfer. Required for \ref svcRestartDma.
    DMACFG_USE_SRC_CONFIG = BIT(6), ///< Use the provided source device configuration even if the DMA source is not a device.
    DMACFG_USE_DST_CONFIG = BIT(7) ///< Use the provided destination device configuration even if the DMA destination is not a device.
}

/// Configuration flags for \ref svcRestartDma.
enum
{
    DMARST_UNLOCK = BIT(0), ///< Unlock the channel after transfer.
    DMARST_RESUME_DEVICE = BIT(1) ///< Replace DMAFLUSHP instructions by NOP (they may not be regenerated even if this flag is not set).
}

/**
 * @brief Device configuration structure, part of \ref DmaConfig.
 * @note
 * - if (and only if) src/dst is a device, then src/dst won't be auto-incremented.
 * - the kernel uses DMAMOV instead of DMAADNH, when having to decrement (possibly working around an erratum);
 * this forces all loops to be unrolled -- you need to keep that in mind when using negative increments, as the kernel
 * uses a limit of 100 DMA instruction bytes per channel.
 */
struct DmaDeviceConfig
{
    byte deviceId; ///< DMA device ID.
    byte allowedAlignments; ///< Mask of allowed access alignments (8, 4, 2, 1).
    short burstSize; ///< Number of bytes transferred in a burst loop. Can be 0 (in which case the max allowed alignment is used as unit).
    short transferSize; ///< Number of bytes transferred in a "transfer" loop (made of burst loops).
    short burstStride; ///< Burst loop stride, can be <= 0.
    short transferStride; ///< "Transfer" loop stride, can be <= 0.
}

/// Configuration stucture for \ref svcStartInterProcessDma.
struct DmaConfig
{
    byte channelId; ///< Channel ID (Arm11: 0-7, Arm9: 0-1). Use -1 to auto-assign to a free channel (Arm11: 3-7, Arm9: 0-1).
    byte endianSwapSize; ///< Endian swap size (can be 0).
    ubyte flags; ///< DMACFG_* flags.
    ubyte _padding;
    DmaDeviceConfig srcCfg; ///< Source device configuration, read if \ref DMACFG_SRC_IS_DEVICE and/or \ref DMACFG_USE_SRC_CONFIG are set.
    DmaDeviceConfig dstCfg; ///< Destination device configuration, read if \ref DMACFG_SRC_IS_DEVICE and/or \ref DMACFG_USE_SRC_CONFIG are set.
}

///@}

///@name Debugging
///@{

/// Operations for \ref svcControlPerformanceCounter
enum PerfCounterOperation
{
    PERFCOUNTEROP_ENABLE = 0, ///< Enable and lock perfmon. functionality.
    PERFCOUNTEROP_DISABLE = 1, ///< Disable and forcibly unlock perfmon. functionality.
    PERFCOUNTEROP_GET_VALUE = 2, ///< Get the value of a counter register.
    PERFCOUNTEROP_SET_VALUE = 3, ///< Set the value of a counter register.
    PERFCOUNTEROP_GET_OVERFLOW_FLAGS = 4, ///< Get the overflow flags for all CP15 and SCU counters.
    PERFCOUNTEROP_RESET = 5, ///< Reset the value and/or overflow flags of selected counters.
    PERFCOUNTEROP_GET_EVENT = 6, ///< Get the event ID associated to a particular counter.
    PERFCOUNTEROP_SET_EVENT = 7, ///< Set the event ID associated to a paritcular counter.
    PERFCOUNTEROP_SET_VIRTUAL_COUNTER_ENABLED = 8 ///< (Dis)allow the kernel to track counter overflows and to use 64-bit counter values.
}

/// Performance counter register IDs (CP15 and SCU).
enum PerfCounterRegister
{
    // CP15 registers:
    PERFCOUNTERREG_CORE_BASE = 0,
    PERFCOUNTERREG_CORE_COUNT_REG_0 = PERFCOUNTERREG_CORE_BASE, ///< CP15 PMN0.
    PERFCOUNTERREG_CORE_COUNT_REG_1 = 1, ///< CP15 PMN1.
    PERFCOUNTERREG_CORE_CYCLE_COUNTER = 2, ///< CP15 CCNT.

    // SCU registers
    PERFCOUNTERREG_SCU_BASE = 0x10,
    PERFCOUNTERREG_SCU_0 = PERFCOUNTERREG_SCU_BASE, ///< SCU MN0.
    PERFCOUNTERREG_SCU_1 = 17, ///< SCU MN1.
    PERFCOUNTERREG_SCU_2 = 18, ///< SCU MN2.
    PERFCOUNTERREG_SCU_3 = 19, ///< SCU MN3.
    PERFCOUNTERREG_SCU_4 = 20, ///< SCU MN4. Prod-N3DS only. IRQ line missing.
    PERFCOUNTERREG_SCU_5 = 21, ///< SCU MN5. Prod-N3DS only. IRQ line missing.
    PERFCOUNTERREG_SCU_6 = 22, ///< SCU MN6. Prod-N3DS only. IRQ line missing.
    PERFCOUNTERREG_SCU_7 = 23 ///< SCU MN7. Prod-N3DS only. IRQ line missing.
}

/**
 * @brief Performance counter event IDs (CP15 or SCU).
 *
 * @note Refer to:
 *     - CP15: https://developer.arm.com/documentation/ddi0360/e/control-coprocessor-cp15/register-descriptions/c15--performance-monitor-control-register--pmnc-
 *     - SCU: https://developer.arm.com/documentation/ddi0360/e/mpcore-private-memory-region/about-the-mpcore-private-memory-region/performance-monitor-event-registers
 */
enum PerfCounterEvent
{
    // Core events:
    PERFCOUNTEREVT_CORE_BASE = 0x0,
    PERFCOUNTEREVT_CORE_INST_CACHE_MISS = PERFCOUNTEREVT_CORE_BASE,
    PERFCOUNTEREVT_CORE_STALL_BY_LACK_OF_INST = 1,
    PERFCOUNTEREVT_CORE_STALL_BY_DATA_HAZARD = 2,
    PERFCOUNTEREVT_CORE_INST_MICRO_TLB_MISS = 3,
    PERFCOUNTEREVT_CORE_DATA_MICRO_TLB_MISS = 4,
    PERFCOUNTEREVT_CORE_BRANCH_INST = 5,
    PERFCOUNTEREVT_CORE_BRANCH_NOT_PREDICTED = 6,
    PERFCOUNTEREVT_CORE_BRANCH_MISS_PREDICTED = 7,
    PERFCOUNTEREVT_CORE_INST_EXECUTED = 8,
    PERFCOUNTEREVT_CORE_FOLDED_INST_EXECUTED = 9,
    PERFCOUNTEREVT_CORE_DATA_CACHE_READ = 10,
    PERFCOUNTEREVT_CORE_DATA_CACHE_READ_MISS = 11,
    PERFCOUNTEREVT_CORE_DATA_CACHE_WRITE = 12,
    PERFCOUNTEREVT_CORE_DATA_CACHE_WRITE_MISS = 13,
    PERFCOUNTEREVT_CORE_DATA_CACHE_LINE_EVICTION = 14,
    PERFCOUNTEREVT_CORE_PC_CHANGED = 15,
    PERFCOUNTEREVT_CORE_MAIN_TLB_MISS = 16,
    PERFCOUNTEREVT_CORE_EXTERNAL_REQUEST = 17,
    PERFCOUNTEREVT_CORE_STALL_BY_LSU_FULL = 18,
    PERFCOUNTEREVT_CORE_STORE_BUFFER_DRAIN = 19,
    PERFCOUNTEREVT_CORE_MERGE_IN_STORE_BUFFER = 20,
    PERFCOUNTEREVT_CORE_CYCLE_COUNT = PERFCOUNTEREVT_CORE_BASE + 0xFF, ///< One cycle elapsed.
    PERFCOUNTEREVT_CORE_CYCLE_COUNT_64 = PERFCOUNTEREVT_CORE_BASE + 0xFFF, ///< 64 cycles elapsed.

    PERFCOUNTEREVT_SCU_BASE = 0x1000,
    PERFCOUNTEREVT_SCU_DISABLED = PERFCOUNTEREVT_SCU_BASE,
    PERFCOUNTEREVT_SCU_LINEFILL_MISS_FROM_CORE0 = 4097,
    PERFCOUNTEREVT_SCU_LINEFILL_MISS_FROM_CORE1 = 4098,
    PERFCOUNTEREVT_SCU_LINEFILL_MISS_FROM_CORE2 = 4099,
    PERFCOUNTEREVT_SCU_LINEFILL_MISS_FROM_CORE3 = 4100,
    PERFCOUNTEREVT_SCU_LINEFILL_HIT_FROM_CORE0 = 4101,
    PERFCOUNTEREVT_SCU_LINEFILL_HIT_FROM_CORE1 = 4102,
    PERFCOUNTEREVT_SCU_LINEFILL_HIT_FROM_CORE2 = 4103,
    PERFCOUNTEREVT_SCU_LINEFILL_HIT_FROM_CORE3 = 4104,
    PERFCOUNTEREVT_SCU_LINE_MISSING_FROM_CORE0 = 4105,
    PERFCOUNTEREVT_SCU_LINE_MISSING_FROM_CORE1 = 4106,
    PERFCOUNTEREVT_SCU_LINE_MISSING_FROM_CORE2 = 4107,
    PERFCOUNTEREVT_SCU_LINE_MISSING_FROM_CORE3 = 4108,
    PERFCOUNTEREVT_SCU_LINE_MIGRATION = 4109,
    PERFCOUNTEREVT_SCU_READ_BUSY_PORT0 = 4110,
    PERFCOUNTEREVT_SCU_READ_BUSY_PORT1 = 4111,
    PERFCOUNTEREVT_SCU_WRITE_BUSY_PORT0 = 4112,
    PERFCOUNTEREVT_SCU_WRITE_BUSY_PORT1 = 4113,
    PERFCOUNTEREVT_SCU_EXTERNAL_READ = 4114,
    PERFCOUNTEREVT_SCU_EXTERNAL_WRITE = 4115,
    PERFCOUNTEREVT_SCU_CYCLE_COUNT = PERFCOUNTEREVT_SCU_BASE + 0x1F
}

/// Event relating to the attachment of a process.
struct AttachProcessEvent
{
    ulong program_id; ///< ID of the program.
    char[8] process_name; ///< Name of the process.
    uint process_id; ///< ID of the process.
    uint other_flags; ///< Always 0
}

/// Reasons for an exit process event.
enum ExitProcessEventReason
{
    EXITPROCESS_EVENT_EXIT = 0, ///< Process exited either normally or due to an uncaught exception.
    EXITPROCESS_EVENT_TERMINATE = 1, ///< Process has been terminated by @ref svcTerminateProcess.
    EXITPROCESS_EVENT_DEBUG_TERMINATE = 2 ///< Process has been terminated by @ref svcTerminateDebugProcess.
}

/// Event relating to the exiting of a process.
struct ExitProcessEvent
{
    ExitProcessEventReason reason; ///< Reason for exiting. See @ref ExitProcessEventReason
}

/// Event relating to the attachment of a thread.
struct AttachThreadEvent
{
    uint creator_thread_id; ///< ID of the creating thread.
    uint thread_local_storage; ///< Thread local storage.
    uint entry_point; ///< Entry point of the thread.
}

/// Reasons for an exit thread event.
enum ExitThreadEventReason
{
    EXITTHREAD_EVENT_EXIT = 0, ///< Thread exited.
    EXITTHREAD_EVENT_TERMINATE = 1, ///< Thread terminated.
    EXITTHREAD_EVENT_EXIT_PROCESS = 2, ///< Process exited either normally or due to an uncaught exception.
    EXITTHREAD_EVENT_TERMINATE_PROCESS = 3 ///< Process has been terminated by @ref svcTerminateProcess.
}

/// Event relating to the exiting of a thread.
struct ExitThreadEvent
{
    ExitThreadEventReason reason; ///< Reason for exiting. See @ref ExitThreadEventReason
}

/// Reasons for a user break.
enum UserBreakType
{
    USERBREAK_PANIC = 0, ///< Panic.
    USERBREAK_ASSERT = 1, ///< Assertion failed.
    USERBREAK_USER = 2, ///< User related.
    USERBREAK_LOAD_RO = 3, ///< Load RO.
    USERBREAK_UNLOAD_RO = 4 ///< Unload RO.
}

/// Reasons for an exception event.
enum ExceptionEventType
{
    EXCEVENT_UNDEFINED_INSTRUCTION = 0, ///< Undefined instruction.
    EXCEVENT_PREFETCH_ABORT = 1, ///< Prefetch abort.
    EXCEVENT_DATA_ABORT = 2, ///< Data abort (other than the below kind).
    EXCEVENT_UNALIGNED_DATA_ACCESS = 3, ///< Unaligned data access.
    EXCEVENT_ATTACH_BREAK = 4, ///< Attached break.
    EXCEVENT_STOP_POINT = 5, ///< Stop point reached.
    EXCEVENT_USER_BREAK = 6, ///< User break occurred.
    EXCEVENT_DEBUGGER_BREAK = 7, ///< Debugger break occurred.
    EXCEVENT_UNDEFINED_SYSCALL = 8 ///< Undefined syscall.
}

/// Event relating to fault exceptions (CPU exceptions other than stop points and undefined syscalls).
struct FaultExceptionEvent
{
    uint fault_information; ///< FAR (for DATA ABORT / UNALIGNED DATA ACCESS), attempted syscall or 0
}

/// Stop point types
enum StopPointType
{
    STOPPOINT_SVC_FF = 0, ///< See @ref SVC_STOP_POINT.
    STOPPOINT_BREAKPOINT = 1, ///< Breakpoint.
    STOPPOINT_WATCHPOINT = 2 ///< Watchpoint.
}

/// Event relating to stop points
struct StopPointExceptionEvent
{
    StopPointType type; ///< Stop point type, see @ref StopPointType.
    uint fault_information; ///< FAR for Watchpoints, otherwise 0.
}

/// Event relating to @ref svcBreak
struct UserBreakExceptionEvent
{
    UserBreakType type; ///< User break type, see @ref UserBreakType.
    uint croInfo; ///< For LOAD_RO and UNLOAD_RO.
    uint croInfoSize; ///< For LOAD_RO and UNLOAD_RO.
}

/// Event relating to @ref svcBreakDebugProcess
struct DebuggerBreakExceptionEvent
{
    int[4] thread_ids; ///< IDs of the attached process's threads that were running on each core at the time of the @ref svcBreakDebugProcess call, or -1 (only the first 2 values are meaningful on O3DS).
}

/// Event relating to exceptions.
struct ExceptionEvent
{
    ExceptionEventType type; ///< Type of event. See @ref ExceptionEventType.
    uint address; ///< Address of the exception.
    union
    {
        FaultExceptionEvent fault; ///< Fault exception event data.
        StopPointExceptionEvent stop_point; ///< Stop point exception event data.
        UserBreakExceptionEvent user_break; ///< User break exception event data.
        DebuggerBreakExceptionEvent debugger_break; ///< Debugger break exception event data
    }
}

/// Event relating to the scheduler.
struct ScheduleInOutEvent
{
    ulong clock_tick; ///< Clock tick that the event occurred.
}

/// Event relating to syscalls.
struct SyscallInOutEvent
{
    ulong clock_tick; ///< Clock tick that the event occurred.
    uint syscall; ///< Syscall sent/received.
}

/// Event relating to debug output.
struct OutputStringEvent
{
    uint string_addr; ///< Address of the outputted string.
    uint string_size; ///< Size of the outputted string.
}

/// Event relating to the mapping of memory.
struct MapEvent
{
    uint mapped_addr; ///< Mapped address.
    uint mapped_size; ///< Mapped size.
    MemPerm memperm; ///< Memory permissions. See @ref MemPerm.
    MemState memstate; ///< Memory state. See @ref MemState.
}

/// Debug event type.
enum DebugEventType
{
    DBGEVENT_ATTACH_PROCESS = 0, ///< Process attached event.
    DBGEVENT_ATTACH_THREAD = 1, ///< Thread attached event.
    DBGEVENT_EXIT_THREAD = 2, ///< Thread exit event.
    DBGEVENT_EXIT_PROCESS = 3, ///< Process exit event.
    DBGEVENT_EXCEPTION = 4, ///< Exception event.
    DBGEVENT_DLL_LOAD = 5, ///< DLL load event.
    DBGEVENT_DLL_UNLOAD = 6, ///< DLL unload event.
    DBGEVENT_SCHEDULE_IN = 7, ///< Schedule in event.
    DBGEVENT_SCHEDULE_OUT = 8, ///< Schedule out event.
    DBGEVENT_SYSCALL_IN = 9, ///< Syscall in event.
    DBGEVENT_SYSCALL_OUT = 10, ///< Syscall out event.
    DBGEVENT_OUTPUT_STRING = 11, ///< Output string event.
    DBGEVENT_MAP = 12 ///< Map event.
}

/// Information about a debug event.
struct DebugEventInfo
{
    DebugEventType type; ///< Type of event. See @ref DebugEventType
    uint thread_id; ///< ID of the thread.
    uint flags; ///< Flags. Bit0 means that @ref svcContinueDebugEvent needs to be called for this event (except for EXIT PROCESS events, where this flag is disregarded).
    ubyte[4] remnants; ///< Always 0.
    union
    {
        AttachProcessEvent attach_process; ///< Process attachment event data.
        AttachThreadEvent attach_thread; ///< Thread attachment event data.
        ExitThreadEvent exit_thread; ///< Thread exit event data.
        ExitProcessEvent exit_process; ///< Process exit event data.
        ExceptionEvent exception; ///< Exception event data.
        /* DLL_LOAD and DLL_UNLOAD do not seem to possess any event data */
        ScheduleInOutEvent scheduler; ///< Schedule in/out event data.
        SyscallInOutEvent syscall; ///< Syscall in/out event data.
        OutputStringEvent output_string; ///< Output string event data.
        MapEvent map; ///< Map event data.
    }
}

/// Debug flags for an attached process, set by @ref svcContinueDebugEvent
enum DebugFlags
{
    DBG_INHIBIT_USER_CPU_EXCEPTION_HANDLERS = BIT(0), ///< Inhibit user-defined CPU exception handlers (including watchpoints and breakpoints, regardless of any @ref svcKernelSetState call).
    DBG_SIGNAL_FAULT_EXCEPTION_EVENTS = BIT(1), ///< Signal fault exception events. See @ref FaultExceptionEvent.
    DBG_SIGNAL_SCHEDULE_EVENTS = BIT(2), ///< Signal schedule in/out events. See @ref ScheduleInOutEvent.
    DBG_SIGNAL_SYSCALL_EVENTS = BIT(3), ///< Signal syscall in/out events. See @ref SyscallInOutEvent.
    DBG_SIGNAL_MAP_EVENTS = BIT(4) ///< Signal map events. See @ref MapEvent.
}

struct ThreadContext
{
    CpuRegisters cpu_registers; ///< CPU registers.
    FpuRegisters fpu_registers; ///< FPU registers.
}

/// Control flags for @ref svcGetDebugThreadContext and @ref svcSetDebugThreadContext
enum ThreadContextControlFlags
{
    THREADCONTEXT_CONTROL_CPU_GPRS = BIT(0), ///< Control r0-r12.
    THREADCONTEXT_CONTROL_CPU_SPRS = BIT(1), ///< Control sp, lr, pc, cpsr.
    THREADCONTEXT_CONTROL_FPU_GPRS = BIT(2), ///< Control d0-d15 (or s0-s31).
    THREADCONTEXT_CONTROL_FPU_SPRS = BIT(3), ///< Control fpscr, fpexc.

    THREADCONTEXT_CONTROL_CPU_REGS = BIT(0) | BIT(1), ///< Control r0-r12, sp, lr, pc, cpsr.
    THREADCONTEXT_CONTROL_FPU_REGS = BIT(2) | BIT(3), ///< Control d0-d15, fpscr, fpexc.

    THREADCONTEXT_CONTROL_ALL = BIT(0) | BIT(1) | BIT(2) | BIT(3) ///< Control all of the above.
}

/// Thread parameter field for @ref svcGetDebugThreadParameter
enum DebugThreadParameter
{
    DBGTHREAD_PARAMETER_PRIORITY = 0, ///< Thread priority.
    DBGTHREAD_PARAMETER_SCHEDULING_MASK_LOW = 1, ///< Low scheduling mask.
    DBGTHREAD_PARAMETER_CPU_IDEAL = 2, ///< Ideal processor.
    DBGTHREAD_PARAMETER_CPU_CREATOR = 3 ///< Processor that created the threod.
}

///@}

///@name Processes
///@{

/// Information on address space for process. All sizes are in pages (0x1000 bytes)
struct CodeSetHeader
{
    ubyte[8] name; ///< ASCII name of codeset
    ushort version_; ///< Version field of codeset (unused)
    ushort[3] padding; ///< Padding
    uint text_addr; ///< .text start address
    uint text_size; ///< .text number of pages
    uint ro_addr; ///< .rodata start address
    uint ro_size; ///< .rodata number of pages
    uint rw_addr; ///< .data, .bss start address
    uint rw_size; ///< .data number of pages
    uint text_size_total; ///< total pages for .text (aligned)
    uint ro_size_total; ///< total pages for .rodata (aligned)
    uint rw_size_total; ///< total pages for .data, .bss (aligned)
    uint padding2; ///< Padding
    ulong program_id; ///< Program ID
}

/// Information for the main thread of a process.
struct StartupInfo
{
    int priority; ///< Priority of the main thread.
    uint stack_size; ///< Size of the stack of the main thread.
    int argc; ///< Unused on retail kernel.
    ushort* argv; ///< Unused on retail kernel.
    ushort* envp; ///< Unused on retail kernel.
}

///@}

/**
 * @brief Gets the thread local storage buffer.
 * @return The thread local storage buffer.
 */
extern(D) void* getThreadLocalStorage ()
{
  void* ret;
  asm @nogc nothrow
  {
    //"mrc p15, 0, %[data], c13, c0, 3" : [data] "=r" (ret);
    "mrc p15, 0, %0, c13, c0, 3" : "=r"(ret);
  }
  return ret;
}

/**
 * @brief Gets the thread command buffer.
 * @return The thread command buffer.
 */
extern(D) uint* getThreadCommandBuffer ()
{
  return cast(uint*)(cast(ubyte*)getThreadLocalStorage() + 0x80);
}

/**
 * @brief Gets the thread static buffer.
 * @return The thread static buffer.
 */
extern(D) uint* getThreadStaticBuffers ()
{
  return cast(uint*)(cast(ubyte*) getThreadLocalStorage() + 0x180);
}

///@name Device drivers
///@{

/// Writes the default DMA device config that the kernel uses when DMACFG_*_IS_DEVICE and DMACFG_*_USE_CFG are not set

// Kernel uses this default instance if _IS_DEVICE and _USE_CFG are not set
extern(D) void dmaDeviceConfigInitDefault (DmaDeviceConfig* cfg)
{
  *cfg = DmaDeviceConfig(
    -1,
    8 | 4 | 2 | 1,
    0x80,
    0,
    0x80,
    0
  );
}

/// Initializes a \ref DmaConfig instance with sane defaults for RAM<>RAM tranfers
extern(D) void dmaConfigInitDefault (DmaConfig* cfg)
{
  *cfg = DmaConfig(
    -1,
    0,
    DMACFG_WAIT_AVAILABLE,
    0,
    DmaDeviceConfig.init,
    DmaDeviceConfig.init
  );
}

///@}

///@name Memory management
///@{
/**
 * @brief Controls memory mapping
 * @param[out] addr_out The virtual address resulting from the operation. Usually the same as addr0.
 * @param addr0    The virtual address to be used for the operation.
 * @param addr1    The virtual address to be (un)mirrored by @p addr0 when using @ref MEMOP_MAP or @ref MEMOP_UNMAP.
 *                 It has to be pointing to a RW memory.
 *                 Use NULL if the operation is @ref MEMOP_FREE or @ref MEMOP_ALLOC.
 * @param size     The requested size for @ref MEMOP_ALLOC and @ref MEMOP_ALLOC_LINEAR.
 * @param op       Operation flags. See @ref MemOp.
 * @param perm     A combination of @ref MEMPERM_READ and @ref MEMPERM_WRITE. Using MEMPERM_EXECUTE will return an error.
 *                 Value 0 is used when unmapping memory.
 *
 * If a memory is mapped for two or more addresses, you have to use MEMOP_UNMAP before being able to MEMOP_FREE it.
 * MEMOP_MAP will fail if @p addr1 was already mapped to another address.
 *
 * More information is available at http://3dbrew.org/wiki/SVC#Memory_Mapping.
 *
 * @sa svcControlProcessMemory
 */
Result svcControlMemory (uint* addr_out, uint addr0, uint addr1, uint size, MemOp op, MemPerm perm);

/**
 * @brief Controls the memory mapping of a process
 * @param addr0 The virtual address to map
 * @param addr1 The virtual address to be mapped by @p addr0
 * @param type Only operations @ref MEMOP_MAP, @ref MEMOP_UNMAP and @ref MEMOP_PROT are allowed.
 *
 * This is the only SVC which allows mapping executable memory.
 * Using @ref MEMOP_PROT will change the memory permissions of an already mapped memory.
 *
 * @note The pseudo handle for the current process is not supported by this service call.
 * @sa svcControlProcess
 */
Result svcControlProcessMemory (Handle process, uint addr0, uint addr1, uint size, uint type, uint perm);

/**
 * @brief Creates a block of shared memory
 * @param[out] memblock Pointer to store the handle of the block
 * @param addr Address of the memory to map, page-aligned. So its alignment must be 0x1000.
 * @param size Size of the memory to map, a multiple of 0x1000.
 * @param my_perm Memory permissions for the current process
 * @param other_perm Memory permissions for the other processes
 *
 * @note The shared memory block, and its rights, are destroyed when the handle is closed.
 */
Result svcCreateMemoryBlock (Handle* memblock, uint addr, uint size, MemPerm my_perm, MemPerm other_perm);

/**
 * @brief Maps a block of shared memory
 * @param memblock Handle of the block
 * @param addr Address of the memory to map, page-aligned. So its alignment must be 0x1000.
 * @param my_perm Memory permissions for the current process
 * @param other_perm Memory permissions for the other processes
 *
 * @note The shared memory block, and its rights, are destroyed when the handle is closed.
 */
Result svcMapMemoryBlock (Handle memblock, uint addr, MemPerm my_perm, MemPerm other_perm);

/**
 * @brief Maps a block of process memory, starting from address 0x00100000.
 * @param process Handle of the process.
 * @param destAddress Address of the block of memory to map, in the current (destination) process.
 * @param size Size of the block of memory to map (truncated to a multiple of 0x1000 bytes).
 */
Result svcMapProcessMemory (Handle process, uint destAddress, uint size);

/**
 * @brief Unmaps a block of process memory, starting from address 0x00100000.
 * @param process Handle of the process.
 * @param destAddress Address of the block of memory to unmap, in the current (destination) process.
 * @param size Size of the block of memory to unmap (truncated to a multiple of 0x1000 bytes).
 */
Result svcUnmapProcessMemory (Handle process, uint destAddress, uint size);

/**
 * @brief Unmaps a block of shared memory
 * @param memblock Handle of the block
 * @param addr Address of the memory to unmap, page-aligned. So its alignment must be 0x1000.
 */
Result svcUnmapMemoryBlock (Handle memblock, uint addr);

/**
 * @brief Queries memory information.
 * @param[out] info Pointer to output memory info to.
 * @param out Pointer to output page info to.
 * @param addr Virtual memory address to query.
 */
Result svcQueryMemory (MemInfo* info, PageInfo* out_, uint addr);

/**
 * @brief Queries process memory information.
 * @param[out] info Pointer to output memory info to.
 * @param[out] out Pointer to output page info to.
 * @param process Process to query memory from.
 * @param addr Virtual memory address to query.
 */
Result svcQueryProcessMemory (MemInfo* info, PageInfo* out_, Handle process, uint addr);

///@}

///@name Process management
///@{
/**
 * @brief Gets the handle of a process.
 * @param[out] process   The handle of the process
 * @param      processId The ID of the process to open
 */
Result svcOpenProcess (Handle* process, uint processId);

/// Exits the current process.
void svcExitProcess ();

/**
 * @brief Terminates a process.
 * @param process Handle of the process to terminate.
 */
Result svcTerminateProcess (Handle process);

/**
 * @brief Gets information about a process.
 * @param[out] out Pointer to output process info to.
 * @param process Handle of the process to get information about.
 * @param type Type of information to retreieve.
 */
Result svcGetProcessInfo (long* out_, Handle process, uint type);

/**
 * @brief Gets the ID of a process.
 * @param[out] out Pointer to output the process ID to.
 * @param handle Handle of the process to get the ID of.
 */
Result svcGetProcessId (uint* out_, Handle handle);

/**
 * @brief Gets a list of running processes.
 * @param[out] processCount Pointer to output the process count to.
 * @param[out] processIds Pointer to output the process IDs to.
 * @param processIdMaxCount Maximum number of process IDs.
 */
Result svcGetProcessList (int* processCount, uint* processIds, int processIdMaxCount);

/**
 * @brief Gets a list of the threads of a process.
 * @param[out] threadCount Pointer to output the thread count to.
 * @param[out] threadIds Pointer to output the thread IDs to.
 * @param threadIdMaxCount Maximum number of thread IDs.
 * @param process Process handle to list the threads of.
 */
Result svcGetThreadList (int* threadCount, uint* threadIds, int threadIdMaxCount, Handle process);

/**
 * @brief Creates a port.
 * @param[out] portServer Pointer to output the port server handle to.
 * @param[out] portClient Pointer to output the port client handle to.
 * @param name Name of the port.
 * @param maxSessions Maximum number of sessions that can connect to the port.
 */
Result svcCreatePort (Handle* portServer, Handle* portClient, const(char)* name, int maxSessions);

/**
 * @brief Connects to a port.
 * @param[out] out Pointer to output the port handle to.
 * @param portName Name of the port.
 */
Result svcConnectToPort (Handle* out_, const(char)* portName);

/**
 * @brief Sets up virtual address space for a new process.
 * @param[out] out Pointer to output the codeset handle to.
 * @param info Codeset header, contains process name, titleId and segment info.
 * @param textSegmentLma Address of executable segment in caller's address space.
 * @param roSegmentLma Address of read-only segment in caller's address space.
 * @param dataSegmentLma Address of read-write segment in caller's address space.
 * @note On success, the provided segments are unmapped from the caller's address space.
 */
Result svcCreateCodeSet (Handle* out_, const(CodeSetHeader)* info, uint textSegmentLma, uint roSegmentLma, uint dataSegmentLma);

/**
 * @brief Create a new process.
 * @param[out] out Pointer to output the process handle to.
 * @param codeset Codeset created for this process.
 * @param arm11KernelCaps Arm11 Kernel Capabilities from exheader.
 * @param numArm11KernelCaps Number of kernel capabilities.
 */
Result svcCreateProcess (Handle* out_, Handle codeset, const(uint)* arm11KernelCaps, int numArm11KernelCaps);

/**
 * @brief Gets a process's affinity mask.
 * @param[out] affinitymask Pointer to store the affinity masks.
 * @param process Handle of the process.
 * @param processorcount Number of processors.
 */
Result svcGetProcessAffinityMask (ubyte* affinitymask, Handle process, int processorcount);

/**
 * @brief Sets a process's affinity mask.
 * @param process Handle of the process.
 * @param affinitymask Pointer to retrieve the affinity masks from.
 * @param processorcount Number of processors.
 */
Result svcSetProcessAffinityMask (Handle process, const(ubyte)* affinitymask, int processorcount);

/**
 * Gets a process's ideal processor.
 * @param[out] processorid Pointer to store the ID of the process's ideal processor.
 * @param process Handle of the process.
 */
Result svcGetProcessIdealProcessor (int* processorid, Handle process);

/**
 * Sets a process's ideal processor.
 * @param process Handle of the process.
 * @param processorid ID of the process's ideal processor.
 */
Result svcSetProcessIdealProcessor (Handle process, int processorid);

/**
 * Launches the main thread of the process.
 * @param process Handle of the process.
 * @param info Pointer to a StartupInfo structure describing information for the main thread.
 */
Result svcRun (Handle process, const(StartupInfo)* info);

///@}

///@name Multithreading
///@{
/**
 * @brief Creates a new thread.
 * @param[out] thread     The thread handle
 * @param entrypoint      The function that will be called first upon thread creation
 * @param arg             The argument passed to @p entrypoint
 * @param stack_top       The top of the thread's stack. Must be 0x8 bytes mem-aligned.
 * @param thread_priority Low values gives the thread higher priority.
 *                        For userland apps, this has to be within the range [0x18;0x3F]
 * @param processor_id    The id of the processor the thread should be ran on. Those are labelled starting from 0.
 *                        For old 3ds it has to be <2, and for new 3DS <4.
 *                        Value -1 means all CPUs and -2 read from the Exheader.
 *
 * The processor with ID 1 is the system processor.
 * To enable multi-threading on this core you need to call APT_SetAppCpuTimeLimit at least once with a non-zero value.
 *
 * Since a thread is considered as a waitable object, you can use @ref svcWaitSynchronization
 * and @ref svcWaitSynchronizationN to join with it.
 *
 * @note The kernel will clear the @p stack_top's address low 3 bits to make sure it is 0x8-bytes aligned.
 */
Result svcCreateThread (Handle* thread, ThreadFunc entrypoint, uint arg, uint* stack_top, int thread_priority, int processor_id);

/**
 * @brief Gets the handle of a thread.
 * @param[out] thread  The handle of the thread
 * @param      process The ID of the process linked to the thread
 */
Result svcOpenThread (Handle* thread, Handle process, uint threadId);

/**
 * @brief Exits the current thread.
 *
 * This will trigger a state change and hence release all @ref svcWaitSynchronization operations.
 * It means that you can join a thread by calling @code svcWaitSynchronization(threadHandle,yourtimeout); @endcode
 */
void svcExitThread ();

/**
 * @brief Puts the current thread to sleep.
 * @param ns The minimum number of nanoseconds to sleep for.
 */
void svcSleepThread (long ns);

/// Retrieves the priority of a thread.
Result svcGetThreadPriority (int* out_, Handle handle);

/**
 * @brief Changes the priority of a thread
 * @param prio For userland apps, this has to be within the range [0x18;0x3F]
 *
 * Low values gives the thread higher priority.
 */
Result svcSetThreadPriority (Handle thread, int prio);

/**
 * @brief Gets a thread's affinity mask.
 * @param[out] affinitymask Pointer to output the affinity masks to.
 * @param thread Handle of the thread.
 * @param processorcount Number of processors.
 */
Result svcGetThreadAffinityMask (ubyte* affinitymask, Handle thread, int processorcount);

/**
 * @brief Sets a thread's affinity mask.
 * @param thread Handle of the thread.
 * @param affinitymask Pointer to retrieve the affinity masks from.
 * @param processorcount Number of processors.
 */
Result svcSetThreadAffinityMask (Handle thread, const(ubyte)* affinitymask, int processorcount);

/**
 * @brief Gets a thread's ideal processor.
 * @param[out] processorid Pointer to output the ID of the thread's ideal processor to.
 * @param thread Handle of the thread.
 */
Result svcGetThreadIdealProcessor (int* processorid, Handle thread);

/**
 * Sets a thread's ideal processor.
 * @param thread Handle of the thread.
 * @param processorid ID of the thread's ideal processor.
 */
Result svcSetThreadIdealProcessor (Handle thread, int processorid);

/**
 * @brief Returns the ID of the processor the current thread is running on.
 * @sa svcCreateThread
 */
int svcGetProcessorID ();

/**
 * @brief Gets the ID of a thread.
 * @param[out] out Pointer to output the thread ID of the thread @p handle to.
 * @param handle Handle of the thread.
 */
Result svcGetThreadId (uint* out_, Handle handle);

/**
 * @brief Gets the resource limit set of a process.
 * @param[out] resourceLimit Pointer to output the resource limit set handle to.
 * @param process Process to get the resource limits of.
 */
Result svcGetResourceLimit (Handle* resourceLimit, Handle process);

/**
 * @brief Gets the value limits of a resource limit set.
 * @param[out] values Pointer to output the value limits to.
 * @param resourceLimit Resource limit set to use.
 * @param names Resource limit names to get the limits of.
 * @param nameCount Number of resource limit names.
 */
Result svcGetResourceLimitLimitValues (long* values, Handle resourceLimit, ResourceLimitType* names, int nameCount);

/**
 * @brief Gets the values of a resource limit set.
 * @param[out] values Pointer to output the values to.
 * @param resourceLimit Resource limit set to use.
 * @param names Resource limit names to get the values of.
 * @param nameCount Number of resource limit names.
 */
Result svcGetResourceLimitCurrentValues (long* values, Handle resourceLimit, ResourceLimitType* names, int nameCount);

/**
 * @brief Sets the resource limit set of a process.
 * @param process Process to set the resource limit set to.
 * @param resourceLimit Resource limit set handle.
 */
Result svcSetProcessResourceLimits (Handle process, Handle resourceLimit);

/**
 * @brief Creates a resource limit set.
 * @param[out] resourceLimit Pointer to output the resource limit set handle to.
 */
Result svcCreateResourceLimit (Handle* resourceLimit);

/**
 * @brief Sets the value limits of a resource limit set.
 * @param resourceLimit Resource limit set to use.
 * @param names Resource limit names to set the limits of.
 * @param values Value limits to set. The high 32 bits of RESLIMIT_COMMIT are used to
                 set APPMEMALLOC in configuration memory, otherwise those bits are unused.
 * @param nameCount Number of resource limit names.
 */
Result svcSetResourceLimitValues (Handle resourceLimit, const(ResourceLimitType)* names, const(long)* values, int nameCount);

/**
 * @brief Gets the process ID of a thread.
 * @param[out] out Pointer to output the process ID of the thread @p handle to.
 * @param handle Handle of the thread.
 * @sa svcOpenProcess
 */
Result svcGetProcessIdOfThread (uint* out_, Handle handle);

/**
 * @brief Checks if a thread handle is valid.
 * This requests always return an error when called, it only checks if the handle is a thread or not.
 * @return 0xD8E007ED (BAD_ENUM) if the Handle is a Thread Handle
 * @return 0xD8E007F7 (BAD_HANDLE) if it isn't.
 */
Result svcGetThreadInfo (long* out_, Handle thread, ThreadInfoType type);
///@}

///@name Synchronization
///@{
/**
 * @brief Creates a mutex.
 * @param[out] mutex Pointer to output the handle of the created mutex to.
 * @param initially_locked Whether the mutex should be initially locked.
 */
Result svcCreateMutex (Handle* mutex, bool initially_locked);

/**
 * @brief Releases a mutex.
 * @param handle Handle of the mutex.
 */
Result svcReleaseMutex (Handle handle);

/**
 * @brief Creates a semaphore.
 * @param[out] semaphore Pointer to output the handle of the created semaphore to.
 * @param initial_count Initial count of the semaphore.
 * @param max_count Maximum count of the semaphore.
 */
Result svcCreateSemaphore (Handle* semaphore, int initial_count, int max_count);

/**
 * @brief Releases a semaphore.
 * @param[out] count Pointer to output the current count of the semaphore to.
 * @param semaphore Handle of the semaphore.
 * @param release_count Number to increase the semaphore count by.
 */
Result svcReleaseSemaphore (int* count, Handle semaphore, int release_count);

/**
 * @brief Creates an event handle.
 * @param[out] event Pointer to output the created event handle to.
 * @param reset_type Type of reset the event uses (RESET_ONESHOT/RESET_STICKY).
 */
Result svcCreateEvent (Handle* event, ResetType reset_type);

/**
 * @brief Signals an event.
 * @param handle Handle of the event to signal.
 */
Result svcSignalEvent (Handle handle);

/**
 * @brief Clears an event.
 * @param handle Handle of the event to clear.
 */
Result svcClearEvent (Handle handle);

/**
 * @brief Waits for synchronization on a handle.
 * @param handle Handle to wait on.
 * @param nanoseconds Maximum nanoseconds to wait for.
 */
Result svcWaitSynchronization (Handle handle, long nanoseconds);

/**
 * @brief Waits for synchronization on multiple handles.
 * @param[out] out Pointer to output the index of the synchronized handle to.
 * @param handles Handles to wait on.
 * @param handles_num Number of handles.
 * @param wait_all Whether to wait for synchronization on all handles.
 * @param nanoseconds Maximum nanoseconds to wait for.
 */
Result svcWaitSynchronizationN (int* out_, const(Handle)* handles, int handles_num, bool wait_all, long nanoseconds);

/**
 * @brief Creates an address arbiter
 * @param[out] mutex Pointer to output the handle of the created address arbiter to.
 * @sa svcArbitrateAddress
 */
Result svcCreateAddressArbiter (Handle* arbiter);

/**
 * @brief Arbitrate an address, can be used for synchronization
 * @param arbiter Handle of the arbiter
 * @param addr A pointer to a s32 value.
 * @param type Type of action to be performed by the arbiter
 * @param value Number of threads to signal if using @ref ARBITRATION_SIGNAL, or the value used for comparison.
 * @param timeout_ns Optional timeout in nanoseconds when using TIMEOUT actions, ignored otherwise. If not needed, use \ref svcArbitrateAddressNoTimeout instead.
 * @note Usage of this syscall entails an implicit Data Memory Barrier (dmb).
 * @warning Please use \ref syncArbitrateAddressWithTimeout instead.
 */
Result svcArbitrateAddress (Handle arbiter, uint addr, ArbitrationType type, int value, long timeout_ns);

/**
 * @brief Same as \ref svcArbitrateAddress but with the timeout_ns parameter undefined.
 * @param arbiter Handle of the arbiter
 * @param addr A pointer to a s32 value.
 * @param type Type of action to be performed by the arbiter
 * @param value Number of threads to signal if using @ref ARBITRATION_SIGNAL, or the value used for comparison.
 * @note Usage of this syscall entails an implicit Data Memory Barrier (dmb).
 * @warning Please use \ref syncArbitrateAddress instead.
 */
Result svcArbitrateAddressNoTimeout (Handle arbiter, uint addr, ArbitrationType type, int value);

/**
 * @brief Sends a synchronized request to a session handle.
 * @param session Handle of the session.
 */
Result svcSendSyncRequest (Handle session);

/**
 * @brief Connects to a port via a handle.
 * @param[out] clientSession Pointer to output the client session handle to.
 * @param clientPort Port client endpoint to connect to.
 */
Result svcCreateSessionToPort (Handle* clientSession, Handle clientPort);

/**
 * @brief Creates a linked pair of session endpoints.
 * @param[out] serverSession Pointer to output the created server endpoint handle to.
 * @param[out] clientSession Pointer to output the created client endpoint handle to.
 */
Result svcCreateSession (Handle* serverSession, Handle* clientSession);

/**
 * @brief Accepts a session.
 * @param[out] session Pointer to output the created session handle to.
 * @param port Handle of the port to accept a session from.
 */
Result svcAcceptSession (Handle* session, Handle port);

/**
 * @brief Replies to and receives a new request.
 * @param index Pointer to the index of the request.
 * @param handles Session handles to receive requests from.
 * @param handleCount Number of handles.
 * @param replyTarget Handle of the session to reply to.
 */
Result svcReplyAndReceive (int* index, const(Handle)* handles, int handleCount, Handle replyTarget);

///@}

///@name Time
///@{
/**
 * @brief Creates a timer.
 * @param[out] timer Pointer to output the handle of the created timer to.
 * @param reset_type Type of reset to perform on the timer.
 */
Result svcCreateTimer (Handle* timer, ResetType reset_type);

/**
 * @brief Sets a timer.
 * @param timer Handle of the timer to set.
 * @param initial Initial value of the timer.
 * @param interval Interval of the timer.
 */
Result svcSetTimer (Handle timer, long initial, long interval);

/**
 * @brief Cancels a timer.
 * @param timer Handle of the timer to cancel.
 */
Result svcCancelTimer (Handle timer);

/**
 * @brief Clears a timer.
 * @param timer Handle of the timer to clear.
 */
Result svcClearTimer (Handle timer);

/**
 * @brief Gets the current system tick.
 * @return The current system tick.
 */
ulong svcGetSystemTick ();
///@}

///@name System
///@{
/**
 * @brief Closes a handle.
 * @param handle Handle to close.
 */
Result svcCloseHandle (Handle handle);

/**
 * @brief Duplicates a handle.
 * @param[out] out Pointer to output the duplicated handle to.
 * @param original Handle to duplicate.
 */
Result svcDuplicateHandle (Handle* out_, Handle original);

/**
 * @brief Gets a handle info.
 * @param[out] out Pointer to output the handle info to.
 * @param handle Handle to get the info for.
 * @param param Parameter clarifying the handle info type.
 */
Result svcGetHandleInfo (long* out_, Handle handle, uint param);

/**
 * @brief Gets the system info.
 * @param[out] out Pointer to output the system info to.
 * @param type Type of system info to retrieve.
 * @param param Parameter clarifying the system info type.
 */
Result svcGetSystemInfo (long* out_, uint type, int param);

/**
 * @brief Sets the current kernel state.
 * @param type Type of state to set (the other parameters depend on it).
 */
Result svcKernelSetState (uint type, ...);
///@}

///@name Device drivers
///@{

/**
 * @brief Binds an event or semaphore handle to an ARM11 interrupt.
 * @param interruptId Interrupt identfier (see https://www.3dbrew.org/wiki/ARM11_Interrupts).
 * @param eventOrSemaphore Event or semaphore handle to bind to the given interrupt.
 * @param priority Priority of the interrupt for the current process.
 * @param isManualClear Indicates whether the interrupt has to be manually cleared or not (= level-high active).
 */
Result svcBindInterrupt (uint interruptId, Handle eventOrSemaphore, int priority, bool isManualClear);

/**
 * @brief Unbinds an event or semaphore handle from an ARM11 interrupt.
 * @param interruptId Interrupt identfier, see (see https://www.3dbrew.org/wiki/ARM11_Interrupts).
 * @param eventOrSemaphore Event or semaphore handle to unbind from the given interrupt.
 */
Result svcUnbindInterrupt (uint interruptId, Handle eventOrSemaphore);

/**
 * @brief Invalidates a process's data cache.
 * @param process Handle of the process.
 * @param addr Address to invalidate.
 * @param size Size of the memory to invalidate.
 */
Result svcInvalidateProcessDataCache (Handle process, uint addr, uint size);

/**
 * @brief Cleans a process's data cache.
 * @param process Handle of the process.
 * @param addr Address to clean.
 * @param size Size of the memory to clean.
 */
Result svcStoreProcessDataCache (Handle process, uint addr, uint size);

/**
 * @brief Flushes (cleans and invalidates) a process's data cache.
 * @param process Handle of the process.
 * @param addr Address to flush.
 * @param size Size of the memory to flush.
 */
Result svcFlushProcessDataCache (Handle process, uint addr, uint size);

/**
 * @brief Begins an inter-process DMA transfer.
 * @param[out] dma Pointer to output the handle of the DMA channel object to.
 * @param dstProcess Destination process handle.
 * @param dstAddr Address in the destination process to write data to.
 * @param srcProcess Source process handle.
 * @param srcAddr Address in the source to read data from.
 * @param size Size of the data to transfer.
 * @param cfg Configuration structure.
 * @note The handle is signaled when the transfer finishes.
 */
Result svcStartInterProcessDma (Handle* dma, Handle dstProcess, uint dstAddr, Handle srcProcess, uint srcAddr, uint size, const(DmaConfig)* cfg);

/**
 * @brief Stops an inter-process DMA transfer.
 * @param dma Handle of the DMA channel object.
 */
Result svcStopDma (Handle dma);

/**
 * @brief Gets the state of an inter-process DMA transfer.
 * @param[out] state Pointer to output the state of the DMA transfer to.
 * @param dma Handle of the DMA channel object.
 */
Result svcGetDmaState (DmaState* state, Handle dma);

/**
 * @brief Restarts a DMA transfer, using the same configuration as before.
 * @param[out] state Pointer to output the state of the DMA transfer to.
 * @param dma Handle of the DMA channel object.
 * @param dstAddr Address in the destination process to write data to.
 * @param srcAddr Address in the source to read data from.
 * @param size Size of the data to transfer.
 * @param flags Restart flags, \ref DMARST_UNLOCK and/or \ref DMARST_RESUME_DEVICE.
 * @note The first transfer has to be configured with \ref DMACFG_KEEP_LOCKED.
 */
Result svcRestartDma (Handle dma, uint dstAddr, uint srcAddr, uint size, byte flags);

/**
 * @brief Sets the GPU protection register to restrict the range of the GPU DMA. 11.3+ only.
 * @param useApplicationRestriction Whether to use the register value used for APPLICATION titles.
 */
Result svcSetGpuProt (bool useApplicationRestriction);

/**
 * @brief Enables or disables Wi-Fi. 11.4+ only.
 * @param enabled Whether to enable or disable Wi-Fi.
 */
Result svcSetWifiEnabled (bool enabled);

///@}

///@name Debugging
///@{
/**
 * @brief Breaks execution.
 * @param breakReason Reason for breaking.
 */
void svcBreak (UserBreakType breakReason);

/**
 * @brief Breaks execution (LOAD_RO and UNLOAD_RO).
 * @param breakReason Debug reason for breaking.
 * @param croInfo Library information.
 * @param croInfoSize Size of the above structure.
 */
void svcBreakRO (UserBreakType breakReason, const(void)* croInfo, uint croInfoSize);

/**
 * @brief Outputs a debug string.
 * @param str String to output.
 * @param length Length of the string to output, needs to be positive.
 */
Result svcOutputDebugString (const(char)* str, int length);

/**
 * @brief Controls performance monitoring on the CP15 interface and the SCU.
 * The meaning of the parameters depend on the operation.
 * @param[out] out Output.
 * @param op Operation, see details.
 * @param param1 First parameter.
 * @param param2 Second parameter.
 * @details The operations are the following:
 *     - \ref PERFCOUNTEROP_ENABLE (void) -> void, tries to enable and lock perfmon. functionality.
 *     - \ref PERFCOUNTEROP_DISABLE (void) -> void, disable and forcibly unlocks perfmon. functionality.
 *     - \ref PERFCOUNTEROP_GET_VALUE (\ref PerfCounterRegister reg) -> u64, gets the value of a particular counter register.
 *     - \ref PERFCOUNTEROP_SET_VALUE (\ref PerfCounterRegister reg, u64 value) -> void, sets the value of a particular counter register.
 *     - \ref PERFCOUNTEROP_GET_OVERFLOW_FLAGS (void) -> u32, gets the overflow flags of all CP15 and SCU registers.
 *         - Format is a bitfield of \ref PerfCounterRegister.
 *     - \ref PERFCOUNTEROP_RESET (u32 valueResetMask, u32 overflowFlagResetMask) -> void, resets the value and/or
 *     overflow flags of selected registers.
 *         - Format is two bitfields of \ref PerfCounterRegister.
 *     - \ref PERFCOUNTEROP_GET_EVENT (\ref PerfCounterRegister reg) -> \ref PerfCounterEvent, gets the event associated
 *     to a particular counter register.
 *     - \ref PERFCOUNTEROP_SET_EVENT (\ref PerfCounterRegister reg, \ref PerfCounterEvent) -> void, sets the event associated
 *     to a particular counter register.
 *     - \ref PERFCOUNTEROP_SET_VIRTUAL_COUNTER_ENABLED (bool enabled) -> void, (dis)allows the kernel to track counter overflows
 *     and to use 64-bit counter values.
 */
Result svcControlPerformanceCounter (ulong* out_, PerfCounterOperation op, uint param1, ulong param2);

/**
 * @brief Creates a debug handle for an active process.
 * @param[out] debug Pointer to output the created debug handle to.
 * @param processId ID of the process to debug.
 */
Result svcDebugActiveProcess (Handle* debug_, uint processId);

/**
 * @brief Breaks a debugged process.
 * @param debug Debug handle of the process.
 */
Result svcBreakDebugProcess (Handle debug_);

/**
 * @brief Terminates a debugged process.
 * @param debug Debug handle of the process.
 */
Result svcTerminateDebugProcess (Handle debug_);

/**
 * @brief Gets the current debug event of a debugged process.
 * @param[out] info Pointer to output the debug event information to.
 * @param debug Debug handle of the process.
 */
Result svcGetProcessDebugEvent (DebugEventInfo* info, Handle debug_);

/**
 * @brief Continues the current debug event of a debugged process (not necessarily the same as @ref svcGetProcessDebugEvent).
 * @param debug Debug handle of the process.
 * @param flags Flags to continue with, see @ref DebugFlags.
 */
Result svcContinueDebugEvent (Handle debug_, DebugFlags flags);

/**
 * @brief Fetches the saved registers of a thread, either inactive or awaiting @ref svcContinueDebugEvent, belonging to a debugged process.
 * @param[out] context Values of the registers to fetch, see @ref ThreadContext.
 * @param debug Debug handle of the parent process.
 * @param threadId ID of the thread to fetch the saved registers of.
 * @param controlFlags Which registers to fetch, see @ref ThreadContextControlFlags.
 */
Result svcGetDebugThreadContext (ThreadContext* context, Handle debug_, uint threadId, ThreadContextControlFlags controlFlags);

/**
 * @brief Updates the saved registers of a thread, either inactive or awaiting @ref svcContinueDebugEvent, belonging to a debugged process.
 * @param debug Debug handle of the parent process.
 * @param threadId ID of the thread to update the saved registers of.
 * @param context Values of the registers to update, see @ref ThreadContext.
 * @param controlFlags Which registers to update, see @ref ThreadContextControlFlags.
 */
Result svcSetDebugThreadContext (Handle debug_, uint threadId, ThreadContext* context, ThreadContextControlFlags controlFlags);

/**
 * @brief Queries memory information of a debugged process.
 * @param[out] info Pointer to output memory info to.
 * @param[out] out Pointer to output page info to.
 * @param debug Debug handle of the process to query memory from.
 * @param addr Virtual memory address to query.
 */
Result svcQueryDebugProcessMemory (MemInfo* info, PageInfo* out_, Handle debug_, uint addr);

/**
 * @brief Reads from a debugged process's memory.
 * @param buffer Buffer to read data to.
 * @param debug Debug handle of the process.
 * @param addr Address to read from.
 * @param size Size of the memory to read.
 */
Result svcReadProcessMemory (void* buffer, Handle debug_, uint addr, uint size);

/**
 * @brief Writes to a debugged process's memory.
 * @param debug Debug handle of the process.
 * @param buffer Buffer to write data from.
 * @param addr Address to write to.
 * @param size Size of the memory to write.
 */
Result svcWriteProcessMemory (Handle debug_, const(void)* buffer, uint addr, uint size);

/**
 * @brief Sets an hardware breakpoint or watchpoint. This is an interface to the BRP/WRP registers, see http://infocenter.arm.com/help/topic/com.arm.doc.ddi0360f/CEGEBGFC.html .
 * @param registerId range 0..5 = breakpoints (BRP0-5), 0x100..0x101 = watchpoints (WRP0-1). The previous stop point for the register is disabled.
 * @param control Value of the control regiser.
 * @param value Value of the value register: either and address (if bit21 of control is clear) or the debug handle of a process to fetch the context ID of.
 */
Result svcSetHardwareBreakPoint (int registerId, uint control, uint value);

/**
 * @brief Gets a debugged thread's parameter.
 * @param[out] unused Unused.
 * @param[out] out Output value.
 * @param debug Debug handle of the process.
 * @param threadId ID of the thread
 * @param parameter Parameter to fetch, see @ref DebugThreadParameter.
 */
Result svcGetDebugThreadParam (long* unused, uint* out_, Handle debug_, uint threadId, DebugThreadParameter parameter);

///@}

/**
 * @brief Executes a function in supervisor mode.
 * @param callback Function to execute.
 */
Result svcBackdoor (int function () callback);

/// Stop point, does nothing if the process is not attached (as opposed to 'bkpt' instructions)
extern(D) void SVC_STOP_POINT()
{
  asm @nogc nothrow
  {
    "svc 0xFF";
  }
}
