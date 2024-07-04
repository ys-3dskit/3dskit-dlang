/**
 * @file ndm.h
 * @brief NDMU service. https://3dbrew.org/wiki/NDM_Services
 */

import ys3ds.ctru._3ds.types;

extern (C):

/// Exclusive states.
enum ndmExclusiveState
{
    NDM_EXCLUSIVE_STATE_NONE = 0,
    NDM_EXCLUSIVE_STATE_INFRASTRUCTURE = 1,
    NDM_EXCLUSIVE_STATE_LOCAL_COMMUNICATIONS = 2,
    NDM_EXCLUSIVE_STATE_STREETPASS = 3,
    NDM_EXCLUSIVE_STATE_STREETPASS_DATA = 4
}

/// Current states.
enum ndmState
{
    NDM_STATE_INITIAL = 0,
    NDM_STATE_SUSPENDED = 1,
    NDM_STATE_INFRASTRUCTURE_CONNECTING = 2,
    NDM_STATE_INFRASTRUCTURE_CONNECTED = 3,
    NDM_STATE_INFRASTRUCTURE_WORKING = 4,
    NDM_STATE_INFRASTRUCTURE_SUSPENDING = 5,
    NDM_STATE_INFRASTRUCTURE_FORCE_SUSPENDING = 6,
    NDM_STATE_INFRASTRUCTURE_DISCONNECTING = 7,
    NDM_STATE_INFRASTRUCTURE_FORCE_DISCONNECTING = 8,
    NDM_STATE_CEC_WORKING = 9,
    NDM_STATE_CEC_FORCE_SUSPENDING = 10,
    NDM_STATE_CEC_SUSPENDING = 11
}

// Daemons.
enum ndmDaemon
{
    NDM_DAEMON_CEC = 0,
    NDM_DAEMON_BOSS = 1,
    NDM_DAEMON_NIM = 2,
    NDM_DAEMON_FRIENDS = 3
}

/// Used to specify multiple daemons.
enum ndmDaemonMask
{
    NDM_DAEMON_MASK_CEC = BIT(ndmDaemon.NDM_DAEMON_CEC),
    NDM_DAEMON_MASK_BOSS = BIT(ndmDaemon.NDM_DAEMON_BOSS),
    NDM_DAEMON_MASK_NIM = BIT(ndmDaemon.NDM_DAEMON_NIM),
    NDM_DAEMON_MASK_FRIENDS = BIT(ndmDaemon.NDM_DAEMON_FRIENDS),
    NDM_DAEMON_MASK_BACKGROUOND = NDM_DAEMON_MASK_CEC | NDM_DAEMON_MASK_BOSS | NDM_DAEMON_MASK_NIM,
    NDM_DAEMON_MASK_ALL = NDM_DAEMON_MASK_CEC | NDM_DAEMON_MASK_BOSS | NDM_DAEMON_MASK_NIM | NDM_DAEMON_MASK_FRIENDS,
    NDM_DAEMON_MASK_DEFAULT = NDM_DAEMON_MASK_CEC | NDM_DAEMON_MASK_FRIENDS
}

// Daemon status.
enum ndmDaemonStatus
{
    NDM_DAEMON_STATUS_BUSY = 0,
    NDM_DAEMON_STATUS_IDLE = 1,
    NDM_DAEMON_STATUS_SUSPENDING = 2,
    NDM_DAEMON_STATUS_SUSPENDED = 3
}

/// Initializes ndmu.
Result ndmuInit ();

/// Exits ndmu.
void ndmuExit ();

/**
 * @brief Sets the network daemon to an exclusive state.
 * @param state State specified in the ndmExclusiveState enumerator.
 */
Result NDMU_EnterExclusiveState (ndmExclusiveState state);

///  Cancels an exclusive state for the network daemon.
Result NDMU_LeaveExclusiveState ();

/**
 * @brief Returns the exclusive state for the network daemon.
 * @param state Pointer to write the exclsuive state to.
 */
Result NDMU_GetExclusiveState (ndmExclusiveState* state);

///  Locks the exclusive state.
Result NDMU_LockState ();

///  Unlocks the exclusive state.
Result NDMU_UnlockState ();

/**
 * @brief Suspends network daemon.
 * @param mask The specified daemon.
 */
Result NDMU_SuspendDaemons (ndmDaemonMask mask);

/**
 * @brief Resumes network daemon.
 * @param mask The specified daemon.
 */
Result NDMU_ResumeDaemons (ndmDaemonMask mask);

/**
 * @brief Suspends scheduling for all network daemons.
 * @param flag 0 = Wait for completion, 1 = Perform in background.
 */
Result NDMU_SuspendScheduler (uint flag);

/// Resumes daemon scheduling.
Result NDMU_ResumeScheduler ();

/**
 * @brief Returns the current state for the network daemon.
 * @param state Pointer to write the current state to.
 */
Result NDMU_GetCurrentState (ndmState* state);

/**
 * @brief Returns the daemon state.
 * @param state Pointer to write the daemons state to.
 */
Result NDMU_QueryStatus (ndmDaemonStatus* status);

/**
 * @brief Sets the scan interval.
 * @param interval Value to set the scan interval to.
 */
Result NDMU_SetScanInterval (uint interval);

/**
 * @brief Returns the scan interval.
 * @param interval Pointer to write the interval value to.
 */
Result NDMU_GetScanInterval (uint* interval);

/**
 * @brief Returns the retry interval.
 * @param interval Pointer to write the interval value to.
 */
Result NDMU_GetRetryInterval (uint* interval);

/// Reverts network daemon to defaults.
Result NDMU_ResetDaemons ();

/**
 * @brief Gets the current default daemon bit mask.
 * @param interval Pointer to write the default daemon mask value to. The default value is (DAEMONMASK_CEC | DAEMONMASK_FRIENDS)
 */
Result NDMU_GetDefaultDaemons (ndmDaemonMask* mask);

///  Clears half awake mac filter.
Result NDMU_ClearMacFilter ();
