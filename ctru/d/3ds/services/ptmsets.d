/**
 * @file ptmsets.h
 * @brief PTMSETS service.
 */

extern (C):

/// Initializes PTMSETS.
Result ptmSetsInit ();

/// Exits PTMSETS.
void ptmSetsExit ();

/**
 * @brief Gets a pointer to the current ptm:sets session handle.
 * @return A pointer to the current ptm:sets session handle.
 */
Handle* ptmSetsGetSessionHandle ();

/**
 * @brief Sets the system time.
 * @param msY2k The number of milliseconds since 01/01/2000.
 */
Result PTMSETS_SetSystemTime (long msY2k);
