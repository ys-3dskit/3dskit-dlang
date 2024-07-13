import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

// Initializes NWMEXT.
Result nwmExtInit ();

// Exits NWMEXT.
void nwmExtExit ();

/**
 * @brief Turns wireless on or off.
 * @param enableWifi True enables it, false disables it.
 */
Result NWMEXT_ControlWirelessEnabled (bool enableWifi);
