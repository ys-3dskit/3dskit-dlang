/**
 * @file gsplcd.h
 * @brief GSPLCD service.
 */

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.services.gspgpu;

extern (C) @nogc nothrow:

/// LCD screens.
enum
{
    GSPLCD_SCREEN_TOP = BIT(GSP_SCREEN_TOP), ///< Top screen.
    GSPLCD_SCREEN_BOTTOM = BIT(GSP_SCREEN_BOTTOM), ///< Bottom screen.
    GSPLCD_SCREEN_BOTH = GSPLCD_SCREEN_TOP | GSPLCD_SCREEN_BOTTOM ///< Both screens.
}

/// Initializes GSPLCD.
Result gspLcdInit ();

/// Exits GSPLCD.
void gspLcdExit ();

/**
 * @brief Gets a pointer to the current gsp::Lcd session handle.
 * @return A pointer to the current gsp::Lcd session handle.
 */
Handle* gspLcdGetSessionHandle ();

/// Powers on both backlights.
Result GSPLCD_PowerOnAllBacklights ();

/// Powers off both backlights.
Result GSPLCD_PowerOffAllBacklights ();

/**
 * @brief Powers on the backlight.
 * @param screen Screen to power on.
 */
Result GSPLCD_PowerOnBacklight (uint screen);

/**
 * @brief Powers off the backlight.
 * @param screen Screen to power off.
 */
Result GSPLCD_PowerOffBacklight (uint screen);

/**
 * @brief Sets 3D_LEDSTATE to the input state value.
 * @param disable False = 3D LED enable, true = 3D LED disable.
 */
Result GSPLCD_SetLedForceOff (bool disable);

/**
 * @brief Gets the LCD screens' vendors. Stubbed on old 3ds.
 * @param vendor Pointer to output the screen vendors to.
 */
Result GSPLCD_GetVendors (ubyte* vendors);

/**
 * @brief Gets the LCD screens' brightness. Stubbed on old 3ds.
 * @param screen Screen to get the brightness value of.
 * @param brightness Brightness value returned.
 */
Result GSPLCD_GetBrightness (uint screen, uint* brightness);

/**
 * @brief Sets the LCD screens' brightness.
 * @param screen Screen to set the brightness value of.
 * @param brightness Brightness value set.
 */
Result GSPLCD_SetBrightness (uint screen, uint brightness);

/**
 * @brief Sets the LCD screens' raw brightness.
 * @param screen Screen to set the brightness value of.
 * @param brightness Brightness value set.
 */
Result GSPLCD_SetBrightnessRaw (uint screen, uint brightness);
