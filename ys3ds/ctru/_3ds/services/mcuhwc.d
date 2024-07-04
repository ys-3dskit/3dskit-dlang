/**
 * @file mcuhwc.h
 * @brief mcuHwc service.
 */

import ys3ds.ctru._3ds.types;

extern (C):

enum powerLedState
{
    LED_NORMAL = 1, ///< The normal mode of the led
    LED_SLEEP_MODE = 2, ///< The led pulses slowly as it does in the sleep mode
    LED_OFF = 3, ///< Switch off power led
    LED_RED = 4, ///< Red state of the led
    LED_BLUE = 5, ///< Blue state of the led
    LED_BLINK_RED = 6 ///< Blinking red state of power led and notification led
}

/// Initializes mcuHwc.
Result mcuHwcInit ();

/// Exits mcuHwc.
void mcuHwcExit ();

/**
 * @brief Gets the current mcuHwc session handle.
 * @return A pointer to the current mcuHwc session handle.
 */
Handle* mcuHwcGetSessionHandle ();

/**
 * @brief Reads data from an i2c device3 register
 * @param reg Register number. See https://www.3dbrew.org/wiki/I2C_Registers#Device_3 for more info
 * @param data Pointer to write the data to.
 * @param size Size of data to be read
 */
Result MCUHWC_ReadRegister (ubyte reg, void* data, uint size);

/**
 * @brief Writes data to a i2c device3 register
 * @param reg Register number. See https://www.3dbrew.org/wiki/I2C_Registers#Device_3 for more info
 * @param data Pointer to write the data to.
 * @param size Size of data to be written
 */
Result MCUHWC_WriteRegister (ubyte reg, const(void)* data, uint size);

/**
 * @brief Gets the battery voltage
 * @param voltage Pointer to write the battery voltage to.
 */
Result MCUHWC_GetBatteryVoltage (ubyte* voltage);

/**
 * @brief Gets the battery level
 * @param level Pointer to write the current battery level to.
 */
Result MCUHWC_GetBatteryLevel (ubyte* level);

/**
 * @brief Gets the sound slider level
 * @param level Pointer to write the slider level to.
 */
Result MCUHWC_GetSoundSliderLevel (ubyte* level);

/**
 * @brief Sets Wifi LED state
 * @param state State of Wifi LED. (True/False)
 */
Result MCUHWC_SetWifiLedState (bool state);

/**
 * @brief Sets Power LED state
 * @param state powerLedState State of power LED.
 */
Result MCUHWC_SetPowerLedState (powerLedState state);

/**
 * @brief Gets 3d slider level
 * @param level Pointer to write 3D slider level to.
 */
Result MCUHWC_Get3dSliderLevel (ubyte* level);

/**
 * @brief Gets the major MCU firmware version
 * @param out Pointer to write the major firmware version to.
 */
Result MCUHWC_GetFwVerHigh (ubyte* out_);

/**
 * @brief Gets the minor MCU firmware version
 * @param out Pointer to write the minor firmware version to.
 */
Result MCUHWC_GetFwVerLow (ubyte* out_);
