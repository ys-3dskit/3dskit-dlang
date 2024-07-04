#pragma once

#include "../types.h"

// Initializes NWMEXT.
Result nwmExtInit(void);

// Exits NWMEXT.
void nwmExtExit(void);

/**
 * @brief Turns wireless on or off.
 * @param enableWifi True enables it, false disables it.
 */
Result NWMEXT_ControlWirelessEnabled(bool enableWifi);
