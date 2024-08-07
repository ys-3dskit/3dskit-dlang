/**
 * @file cam.h
 * @brief CAM service for using the 3DS's front and back cameras.
 */

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.services.y2r;

extern (C) @nogc nothrow:

/// Camera connection target ports.
enum
{
    PORT_NONE = 0x0, ///< No port.
    PORT_CAM1 = BIT(0), ///< CAM1 port.
    PORT_CAM2 = BIT(1), ///< CAM2 port.

    // Port combinations.
    PORT_BOTH = PORT_CAM1 | PORT_CAM2 ///< Both ports.
}

/// Camera combinations.
enum
{
    SELECT_NONE = 0x0, ///< No camera.
    SELECT_OUT1 = BIT(0), ///< Outer camera 1.
    SELECT_IN1 = BIT(1), ///< Inner camera 1.
    SELECT_OUT2 = BIT(2), ///< Outer camera 2.

    // Camera combinations.
    SELECT_IN1_OUT1 = SELECT_OUT1 | SELECT_IN1, ///< Outer camera 1 and inner camera 1.
    SELECT_OUT1_OUT2 = SELECT_OUT1 | SELECT_OUT2, ///< Both outer cameras.
    SELECT_IN1_OUT2 = SELECT_IN1 | SELECT_OUT2, ///< Inner camera 1 and outer camera 2.
    SELECT_ALL = SELECT_OUT1 | SELECT_IN1 | SELECT_OUT2 ///< All cameras.
}

/// Camera contexts.
enum CAMU_Context
{
    CONTEXT_NONE = 0x0, ///< No context.
    CONTEXT_A = BIT(0), ///< Context A.
    CONTEXT_B = BIT(1), ///< Context B.

    // Context combinations.
    CONTEXT_BOTH = CONTEXT_A | CONTEXT_B ///< Both contexts.
}

/// Ways to flip the camera image.
enum CAMU_Flip
{
    FLIP_NONE = 0x0, ///< No flip.
    FLIP_HORIZONTAL = 0x1, ///< Horizontal flip.
    FLIP_VERTICAL = 0x2, ///< Vertical flip.
    FLIP_REVERSE = 0x3 ///< Reverse flip.
}

/// Camera image resolutions.
enum CAMU_Size
{
    SIZE_VGA = 0x0, ///< VGA size.         (640x480)
    SIZE_QVGA = 0x1, ///< QVGA size.        (320x240)
    SIZE_QQVGA = 0x2, ///< QQVGA size.       (160x120)
    SIZE_CIF = 0x3, ///< CIF size.         (352x288)
    SIZE_QCIF = 0x4, ///< QCIF size.        (176x144)
    SIZE_DS_LCD = 0x5, ///< DS LCD size.      (256x192)
    SIZE_DS_LCDx4 = 0x6, ///< DS LCD x4 size.   (512x384)
    SIZE_CTR_TOP_LCD = 0x7, ///< CTR Top LCD size. (400x240)

    // Alias for bottom screen to match top screen naming.
    SIZE_CTR_BOTTOM_LCD = SIZE_QVGA ///< CTR Bottom LCD size. (320x240)
}

/// Camera capture frame rates.
enum CAMU_FrameRate
{
    FRAME_RATE_15 = 0x0, ///< 15 FPS.
    FRAME_RATE_15_TO_5 = 0x1, ///< 15-5 FPS.
    FRAME_RATE_15_TO_2 = 0x2, ///< 15-2 FPS.
    FRAME_RATE_10 = 0x3, ///< 10 FPS.
    FRAME_RATE_8_5 = 0x4, ///< 8.5 FPS.
    FRAME_RATE_5 = 0x5, ///< 5 FPS.
    FRAME_RATE_20 = 0x6, ///< 20 FPS.
    FRAME_RATE_20_TO_5 = 0x7, ///< 20-5 FPS.
    FRAME_RATE_30 = 0x8, ///< 30 FPS.
    FRAME_RATE_30_TO_5 = 0x9, ///< 30-5 FPS.
    FRAME_RATE_15_TO_10 = 0xA, ///< 15-10 FPS.
    FRAME_RATE_20_TO_10 = 0xB, ///< 20-10 FPS.
    FRAME_RATE_30_TO_10 = 0xC ///< 30-10 FPS.
}

/// Camera white balance modes.
enum CAMU_WhiteBalance
{
    WHITE_BALANCE_AUTO = 0x0, ///< Auto white balance.
    WHITE_BALANCE_3200K = 0x1, ///< 3200K white balance.
    WHITE_BALANCE_4150K = 0x2, ///< 4150K white balance.
    WHITE_BALANCE_5200K = 0x3, ///< 5200K white balance.
    WHITE_BALANCE_6000K = 0x4, ///< 6000K white balance.
    WHITE_BALANCE_7000K = 0x5, ///< 7000K white balance.

    // White balance aliases.
    WHITE_BALANCE_NORMAL = WHITE_BALANCE_AUTO, // Normal white balance.      (AUTO)
    WHITE_BALANCE_TUNGSTEN = WHITE_BALANCE_3200K, // Tungsten white balance.    (3200K)
    WHITE_BALANCE_WHITE_FLUORESCENT_LIGHT = WHITE_BALANCE_4150K, // Fluorescent white balance. (4150K)
    WHITE_BALANCE_DAYLIGHT = WHITE_BALANCE_5200K, // Daylight white balance.    (5200K)
    WHITE_BALANCE_CLOUDY = WHITE_BALANCE_6000K, // Cloudy white balance.      (6000K)
    WHITE_BALANCE_HORIZON = WHITE_BALANCE_6000K, // Horizon white balance.     (6000K)
    WHITE_BALANCE_SHADE = WHITE_BALANCE_7000K // Shade white balance.       (7000K)
}

/// Camera photo modes.
enum CAMU_PhotoMode
{
    PHOTO_MODE_NORMAL = 0x0, ///< Normal mode.
    PHOTO_MODE_PORTRAIT = 0x1, ///< Portrait mode.
    PHOTO_MODE_LANDSCAPE = 0x2, ///< Landscape mode.
    PHOTO_MODE_NIGHTVIEW = 0x3, ///< Night mode.
    PHOTO_MODE_LETTER = 0x4 ///< Letter mode.
}

/// Camera special effects.
enum CAMU_Effect
{
    EFFECT_NONE = 0x0, ///< No effects.
    EFFECT_MONO = 0x1, ///< Mono effect.
    EFFECT_SEPIA = 0x2, ///< Sepia effect.
    EFFECT_NEGATIVE = 0x3, ///< Negative effect.
    EFFECT_NEGAFILM = 0x4, ///< Negative film effect.
    EFFECT_SEPIA01 = 0x5 ///< Sepia effect.
}

/// Camera contrast patterns.
enum CAMU_Contrast
{
    CONTRAST_PATTERN_01 = 0x0, ///< Pattern 1.
    CONTRAST_PATTERN_02 = 0x1, ///< Pattern 2.
    CONTRAST_PATTERN_03 = 0x2, ///< Pattern 3.
    CONTRAST_PATTERN_04 = 0x3, ///< Pattern 4.
    CONTRAST_PATTERN_05 = 0x4, ///< Pattern 5.
    CONTRAST_PATTERN_06 = 0x5, ///< Pattern 6.
    CONTRAST_PATTERN_07 = 0x6, ///< Pattern 7.
    CONTRAST_PATTERN_08 = 0x7, ///< Pattern 8.
    CONTRAST_PATTERN_09 = 0x8, ///< Pattern 9.
    CONTRAST_PATTERN_10 = 0x9, ///< Pattern 10.
    CONTRAST_PATTERN_11 = 0xA, ///< Pattern 11.

    // Contrast aliases.
    CONTRAST_LOW = CONTRAST_PATTERN_05, ///< Low contrast.    (5)
    CONTRAST_NORMAL = CONTRAST_PATTERN_06, ///< Normal contrast. (6)
    CONTRAST_HIGH = CONTRAST_PATTERN_07 ///< High contrast.   (7)
}

/// Camera lens correction modes.
enum CAMU_LensCorrection
{
    LENS_CORRECTION_OFF = 0x0, ///< No lens correction.
    LENS_CORRECTION_ON_70 = 0x1, ///< Edge-to-center brightness ratio of 70.
    LENS_CORRECTION_ON_90 = 0x2, ///< Edge-to-center brightness ratio of 90.

    // Lens correction aliases.
    LENS_CORRECTION_DARK = LENS_CORRECTION_OFF, ///< Dark lens correction.   (OFF)
    LENS_CORRECTION_NORMAL = LENS_CORRECTION_ON_70, ///< Normal lens correction. (70)
    LENS_CORRECTION_BRIGHT = LENS_CORRECTION_ON_90 ///< Bright lens correction. (90)
}

/// Camera image output formats.
enum CAMU_OutputFormat
{
    OUTPUT_YUV_422 = 0x0, ///< YUV422
    OUTPUT_RGB_565 = 0x1 ///< RGB565
}

/// Camera shutter sounds.
enum CAMU_ShutterSoundType
{
    SHUTTER_SOUND_TYPE_NORMAL = 0x0, ///< Normal shutter sound.
    SHUTTER_SOUND_TYPE_MOVIE = 0x1, ///< Shutter sound to begin a movie.
    SHUTTER_SOUND_TYPE_MOVIE_END = 0x2 ///< Shutter sound to end a movie.
}

/// Image quality calibration data.
struct CAMU_ImageQualityCalibrationData
{
    short aeBaseTarget; ///< Auto exposure base target brightness.
    short kRL; ///< Left color correction matrix red normalization coefficient.
    short kGL; ///< Left color correction matrix green normalization coefficient.
    short kBL; ///< Left color correction matrix blue normalization coefficient.
    short ccmPosition; ///< Color correction matrix position.
    ushort awbCcmL9Right; ///< Right camera, left color correction matrix red/green gain.
    ushort awbCcmL9Left; ///< Left camera, left color correction matrix red/green gain.
    ushort awbCcmL10Right; ///< Right camera, left color correction matrix blue/green gain.
    ushort awbCcmL10Left; ///< Left camera, left color correction matrix blue/green gain.
    ushort awbX0Right; ///< Right camera, color correction matrix position threshold.
    ushort awbX0Left; ///< Left camera, color correction matrix position threshold.
}

/// Stereo camera calibration data.
struct CAMU_StereoCameraCalibrationData
{
    ubyte isValidRotationXY; ///< #bool Whether the X and Y rotation data is valid.
    ubyte[3] padding; ///< Padding. (Aligns isValidRotationXY to 4 bytes)
    float scale; ///< Scale to match the left camera image with the right.
    float rotationZ; ///< Z axis rotation to match the left camera image with the right.
    float translationX; ///< X axis translation to match the left camera image with the right.
    float translationY; ///< Y axis translation to match the left camera image with the right.
    float rotationX; ///< X axis rotation to match the left camera image with the right.
    float rotationY; ///< Y axis rotation to match the left camera image with the right.
    float angleOfViewRight; ///< Right camera angle of view.
    float angleOfViewLeft; ///< Left camera angle of view.
    float distanceToChart; ///< Distance between cameras and measurement chart.
    float distanceCameras; ///< Distance between left and right cameras.
    short imageWidth; ///< Image width.
    short imageHeight; ///< Image height.
    ubyte[16] reserved; ///< Reserved for future use. (unused)
}

/// Batch camera configuration for use without a context.
struct CAMU_PackageParameterCameraSelect
{
    ubyte camera; ///< Selected camera.
    byte exposure; ///< Camera exposure.
    ubyte whiteBalance; ///< #CAMU_WhiteBalance Camera white balance.
    byte sharpness; ///< Camera sharpness.
    ubyte autoExposureOn; ///< #bool Whether to automatically determine the proper exposure.
    ubyte autoWhiteBalanceOn; ///< #bool Whether to automatically determine the white balance mode.
    ubyte frameRate; ///< #CAMU_FrameRate Camera frame rate.
    ubyte photoMode; ///< #CAMU_PhotoMode Camera photo mode.
    ubyte contrast; ///< #CAMU_Contrast Camera contrast.
    ubyte lensCorrection; ///< #CAMU_LensCorrection Camera lens correction.
    ubyte noiseFilterOn; ///< #bool Whether to enable the camera's noise filter.
    ubyte padding; ///< Padding. (Aligns last 3 fields to 4 bytes)
    short autoExposureWindowX; ///< X of the region to use for auto exposure.
    short autoExposureWindowY; ///< Y of the region to use for auto exposure.
    short autoExposureWindowWidth; ///< Width of the region to use for auto exposure.
    short autoExposureWindowHeight; ///< Height of the region to use for auto exposure.
    short autoWhiteBalanceWindowX; ///< X of the region to use for auto white balance.
    short autoWhiteBalanceWindowY; ///< Y of the region to use for auto white balance.
    short autoWhiteBalanceWindowWidth; ///< Width of the region to use for auto white balance.
    short autoWhiteBalanceWindowHeight; ///< Height of the region to use for auto white balance.
}

/// Batch camera configuration for use with a context.
struct CAMU_PackageParameterContext
{
    ubyte camera; ///< Selected camera.
    ubyte context; ///< #CAMU_Context Selected context.
    ubyte flip; ///< #CAMU_Flip Camera image flip mode.
    ubyte effect; ///< #CAMU_Effect Camera image special effects.
    ubyte size; ///< #CAMU_Size Camera image resolution.
}

/// Batch camera configuration for use with a context and with detailed size information.
struct CAMU_PackageParameterContextDetail
{
    ubyte camera; ///< Selected camera.
    ubyte context; ///< #CAMU_Context Selected context.
    ubyte flip; ///< #CAMU_Flip Camera image flip mode.
    ubyte effect; ///< #CAMU_Effect Camera image special effects.
    short width; ///< Image width.
    short height; ///< Image height.
    short cropX0; ///< First crop point X.
    short cropY0; ///< First crop point Y.
    short cropX1; ///< Second crop point X.
    short cropY1; ///< Second crop point Y.
}

/**
 * @brief Initializes the cam service.
 *
 * This will internally get the handle of the service, and on success call CAMU_DriverInitialize.
 */
Result camInit ();

/**
 * @brief Closes the cam service.
 *
 * This will internally call CAMU_DriverFinalize and close the handle of the service.
 */
void camExit ();

/**
 * Begins capture on the specified camera port.
 * @param port Port to begin capture on.
 */
Result CAMU_StartCapture (uint port);

/**
 * Terminates capture on the specified camera port.
 * @param port Port to terminate capture on.
 */
Result CAMU_StopCapture (uint port);

/**
 * @brief Gets whether the specified camera port is busy.
 * @param busy Pointer to output the busy state to.
 * @param port Port to check.
 */
Result CAMU_IsBusy (bool* busy, uint port);

/**
 * @brief Clears the buffer and error flags of the specified camera port.
 * @param port Port to clear.
 */
Result CAMU_ClearBuffer (uint port);

/**
 * @brief Gets a handle to the event signaled on vsync interrupts.
 * @param event Pointer to output the event handle to.
 * @param port Port to use.
 */
Result CAMU_GetVsyncInterruptEvent (Handle* event, uint port);

/**
 * @brief Gets a handle to the event signaled on camera buffer errors.
 * @param event Pointer to output the event handle to.
 * @param port Port to use.
 */
Result CAMU_GetBufferErrorInterruptEvent (Handle* event, uint port);

/**
 * @brief Initiates the process of receiving a camera frame.
 * @param event Pointer to output the completion event handle to.
 * @param dst Buffer to write data to.
 * @param port Port to receive from.
 * @param imageSize Size of the image to receive.
 * @param transferUnit Transfer unit to use when receiving.
 */
Result CAMU_SetReceiving (Handle* event, void* dst, uint port, uint imageSize, short transferUnit);

/**
 * @brief Gets whether the specified camera port has finished receiving image data.
 * @param finishedReceiving Pointer to output the receiving status to.
 * @param port Port to check.
 */
Result CAMU_IsFinishedReceiving (bool* finishedReceiving, uint port);

/**
 * @brief Sets the number of lines to transfer into an image buffer.
 * @param port Port to use.
 * @param lines Lines to transfer.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_SetTransferLines (uint port, short lines, short width, short height);

/**
 * @brief Gets the maximum number of lines that can be saved to an image buffer.
 * @param maxLines Pointer to write the maximum number of lines to.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_GetMaxLines (short* maxLines, short width, short height);

/**
 * @brief Sets the number of bytes to transfer into an image buffer.
 * @param port Port to use.
 * @param bytes Bytes to transfer.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_SetTransferBytes (uint port, uint bytes, short width, short height);

/**
 * @brief Gets the number of bytes to transfer into an image buffer.
 * @param transferBytes Pointer to write the number of bytes to.
 * @param port Port to use.
 */
Result CAMU_GetTransferBytes (uint* transferBytes, uint port);

/**
 * @brief Gets the maximum number of bytes that can be saved to an image buffer.
 * @param maxBytes Pointer to write the maximum number of bytes to.
 * @param width Width of the image.
 * @param height Height of the image.
 */
Result CAMU_GetMaxBytes (uint* maxBytes, short width, short height);

/**
 * @brief Sets whether image trimming is enabled.
 * @param port Port to use.
 * @param trimming Whether image trimming is enabled.
 */
Result CAMU_SetTrimming (uint port, bool trimming);

/**
 * @brief Gets whether image trimming is enabled.
 * @param trimming Pointer to output the trim state to.
 * @param port Port to use.
 */
Result CAMU_IsTrimming (bool* trimming, uint port);

/**
 * @brief Sets the parameters used for trimming images.
 * @param port Port to use.
 * @param xStart Start X coordinate.
 * @param yStart Start Y coordinate.
 * @param xEnd End X coordinate.
 * @param yEnd End Y coordinate.
 */
Result CAMU_SetTrimmingParams (uint port, short xStart, short yStart, short xEnd, short yEnd);

/**
 * @brief Gets the parameters used for trimming images.
 * @param xStart Pointer to write the start X coordinate to.
 * @param yStart Pointer to write the start Y coordinate to.
 * @param xEnd Pointer to write the end X coordinate to.
 * @param yEnd Pointer to write the end Y coordinate to.
 * @param port Port to use.
 */
Result CAMU_GetTrimmingParams (short* xStart, short* yStart, short* xEnd, short* yEnd, uint port);

/**
 * @brief Sets the parameters used for trimming images, relative to the center of the image.
 * @param port Port to use.
 * @param trimWidth Trim width.
 * @param trimHeight Trim height.
 * @param camWidth Camera width.
 * @param camHeight Camera height.
 */
Result CAMU_SetTrimmingParamsCenter (uint port, short trimWidth, short trimHeight, short camWidth, short camHeight);

/**
 * @brief Activates the specified camera.
 * @param select Camera to use.
 */
Result CAMU_Activate (uint select);

/**
 * @brief Switches the specified camera's active context.
 * @param select Camera to use.
 * @param context Context to use.
 */
Result CAMU_SwitchContext (uint select, CAMU_Context context);

/**
 * @brief Sets the exposure value of the specified camera.
 * @param select Camera to use.
 * @param exposure Exposure value to use.
 */
Result CAMU_SetExposure (uint select, byte exposure);

/**
 * @brief Sets the white balance mode of the specified camera.
 * @param select Camera to use.
 * @param whiteBalance White balance mode to use.
 */
Result CAMU_SetWhiteBalance (uint select, CAMU_WhiteBalance whiteBalance);

/**
 * @brief Sets the white balance mode of the specified camera.
 * TODO: Explain "without base up"?
 * @param select Camera to use.
 * @param whiteBalance White balance mode to use.
 */
Result CAMU_SetWhiteBalanceWithoutBaseUp (uint select, CAMU_WhiteBalance whiteBalance);

/**
 * @brief Sets the sharpness of the specified camera.
 * @param select Camera to use.
 * @param sharpness Sharpness to use.
 */
Result CAMU_SetSharpness (uint select, byte sharpness);

/**
 * @brief Sets whether auto exposure is enabled on the specified camera.
 * @param select Camera to use.
 * @param autoWhiteBalance Whether auto exposure is enabled.
 */
Result CAMU_SetAutoExposure (uint select, bool autoExposure);

/**
 * @brief Gets whether auto exposure is enabled on the specified camera.
 * @param autoExposure Pointer to output the auto exposure state to.
 * @param select Camera to use.
 */
Result CAMU_IsAutoExposure (bool* autoExposure, uint select);

/**
 * @brief Sets whether auto white balance is enabled on the specified camera.
 * @param select Camera to use.
 * @param autoWhiteBalance Whether auto white balance is enabled.
 */
Result CAMU_SetAutoWhiteBalance (uint select, bool autoWhiteBalance);

/**
 * @brief Gets whether auto white balance is enabled on the specified camera.
 * @param autoWhiteBalance Pointer to output the auto white balance state to.
 * @param select Camera to use.
 */
Result CAMU_IsAutoWhiteBalance (bool* autoWhiteBalance, uint select);

/**
 * @brief Flips the image of the specified camera in the specified context.
 * @param select Camera to use.
 * @param flip Flip mode to use.
 * @param context Context to use.
 */
Result CAMU_FlipImage (uint select, CAMU_Flip flip, CAMU_Context context);

/**
 * @brief Sets the image resolution of the given camera in the given context, in detail.
 * @param select Camera to use.
 * @param width Width to use.
 * @param height Height to use.
 * @param cropX0 First crop point X.
 * @param cropY0 First crop point Y.
 * @param cropX1 Second crop point X.
 * @param cropY1 Second crop point Y.
 * @param context Context to use.
 */
Result CAMU_SetDetailSize (uint select, short width, short height, short cropX0, short cropY0, short cropX1, short cropY1, CAMU_Context context);

/**
 * @brief Sets the image resolution of the given camera in the given context.
 * @param select Camera to use.
 * @param size Size to use.
 * @param context Context to use.
 */
Result CAMU_SetSize (uint select, CAMU_Size size, CAMU_Context context);

/**
 * @brief Sets the frame rate of the given camera.
 * @param select Camera to use.
 * @param frameRate Frame rate to use.
 */
Result CAMU_SetFrameRate (uint select, CAMU_FrameRate frameRate);

/**
 * @brief Sets the photo mode of the given camera.
 * @param select Camera to use.
 * @param photoMode Photo mode to use.
 */
Result CAMU_SetPhotoMode (uint select, CAMU_PhotoMode photoMode);

/**
 * @brief Sets the special effects of the given camera in the given context.
 * @param select Camera to use.
 * @param effect Effect to use.
 * @param context Context to use.
 */
Result CAMU_SetEffect (uint select, CAMU_Effect effect, CAMU_Context context);

/**
 * @brief Sets the contrast mode of the given camera.
 * @param select Camera to use.
 * @param contrast Contrast mode to use.
 */
Result CAMU_SetContrast (uint select, CAMU_Contrast contrast);

/**
 * @brief Sets the lens correction mode of the given camera.
 * @param select Camera to use.
 * @param lensCorrection Lens correction mode to use.
 */
Result CAMU_SetLensCorrection (uint select, CAMU_LensCorrection lensCorrection);

/**
 * @brief Sets the output format of the given camera in the given context.
 * @param select Camera to use.
 * @param format Format to output.
 * @param context Context to use.
 */
Result CAMU_SetOutputFormat (uint select, CAMU_OutputFormat format, CAMU_Context context);

/**
 * @brief Sets the region to base auto exposure off of for the specified camera.
 * @param select Camera to use.
 * @param x X of the region.
 * @param y Y of the region.
 * @param width Width of the region.
 * @param height Height of the region.
 */
Result CAMU_SetAutoExposureWindow (uint select, short x, short y, short width, short height);

/**
 * @brief Sets the region to base auto white balance off of for the specified camera.
 * @param select Camera to use.
 * @param x X of the region.
 * @param y Y of the region.
 * @param width Width of the region.
 * @param height Height of the region.
 */
Result CAMU_SetAutoWhiteBalanceWindow (uint select, short x, short y, short width, short height);

/**
 * @brief Sets whether the specified camera's noise filter is enabled.
 * @param select Camera to use.
 * @param noiseFilter Whether the noise filter is enabled.
 */
Result CAMU_SetNoiseFilter (uint select, bool noiseFilter);

/**
 * @brief Synchronizes the specified cameras' vsync timing.
 * @param select1 First camera.
 * @param select2 Second camera.
 */
Result CAMU_SynchronizeVsyncTiming (uint select1, uint select2);

/**
 * @brief Gets the vsync timing record of the specified camera for the specified number of signals.
 * @param timing Pointer to write timing data to. (size "past * sizeof(s64)")
 * @param port Port to use.
 * @param past Number of past timings to retrieve.
 */
Result CAMU_GetLatestVsyncTiming (long* timing, uint port, uint past);

/**
 * @brief Gets the specified camera's stereo camera calibration data.
 * @param data Pointer to output the stereo camera data to.
 */
Result CAMU_GetStereoCameraCalibrationData (CAMU_StereoCameraCalibrationData* data);

/**
 * @brief Sets the specified camera's stereo camera calibration data.
 * @param data Data to set.
 */
Result CAMU_SetStereoCameraCalibrationData (CAMU_StereoCameraCalibrationData data);

/**
 * @brief Writes to the specified I2C register of the specified camera.
 * @param select Camera to write to.
 * @param addr Address to write to.
 * @param data Data to write.
 */
Result CAMU_WriteRegisterI2c (uint select, ushort addr, ushort data);

/**
 * @brief Writes to the specified MCU variable of the specified camera.
 * @param select Camera to write to.
 * @param addr Address to write to.
 * @param data Data to write.
 */
Result CAMU_WriteMcuVariableI2c (uint select, ushort addr, ushort data);

/**
 * @brief Reads the specified I2C register of the specified camera.
 * @param data Pointer to read data to.
 * @param select Camera to read from.
 * @param addr Address to read.
 */
Result CAMU_ReadRegisterI2cExclusive (ushort* data, uint select, ushort addr);

/**
 * @brief Reads the specified MCU variable of the specified camera.
 * @param data Pointer to read data to.
 * @param select Camera to read from.
 * @param addr Address to read.
 */
Result CAMU_ReadMcuVariableI2cExclusive (ushort* data, uint select, ushort addr);

/**
 * @brief Sets the specified camera's image quality calibration data.
 * @param data Data to set.
 */
Result CAMU_SetImageQualityCalibrationData (CAMU_ImageQualityCalibrationData data);

/**
 * @brief Gets the specified camera's image quality calibration data.
 * @param data Pointer to write the quality data to.
 */
Result CAMU_GetImageQualityCalibrationData (CAMU_ImageQualityCalibrationData* data);

/**
 * @brief Configures a camera with pre-packaged configuration data without a context.
 * @param Parameter to use.
 */
Result CAMU_SetPackageParameterWithoutContext (CAMU_PackageParameterCameraSelect param);

/**
 * @brief Configures a camera with pre-packaged configuration data with a context.
 * @param Parameter to use.
 */
Result CAMU_SetPackageParameterWithContext (CAMU_PackageParameterContext param);

/**
 * @brief Configures a camera with pre-packaged configuration data without a context and extra resolution details.
 * @param Parameter to use.
 */
Result CAMU_SetPackageParameterWithContextDetail (CAMU_PackageParameterContextDetail param);

/**
 * @brief Gets the Y2R coefficient applied to image data by the camera.
 * @param coefficient Pointer to output the Y2R coefficient to.
 */
Result CAMU_GetSuitableY2rStandardCoefficient (Y2RU_StandardCoefficient* coefficient);

/**
 * @brief Plays the specified shutter sound.
 * @param sound Shutter sound to play.
 */
Result CAMU_PlayShutterSound (CAMU_ShutterSoundType sound);

/// Initializes the camera driver.
Result CAMU_DriverInitialize ();

/// Finalizes the camera driver.
Result CAMU_DriverFinalize ();

/**
 * @brief Gets the current activated camera.
 * @param select Pointer to output the current activated camera to.
 */
Result CAMU_GetActivatedCamera (uint* select);

/**
 * @brief Gets the current sleep camera.
 * @param select Pointer to output the current sleep camera to.
 */
Result CAMU_GetSleepCamera (uint* select);

/**
 * @brief Sets the current sleep camera.
 * @param select Camera to set.
 */
Result CAMU_SetSleepCamera (uint select);

/**
 * @brief Sets whether to enable synchronization of left and right camera brightnesses.
 * @param brightnessSynchronization Whether to enable brightness synchronization.
 */
Result CAMU_SetBrightnessSynchronization (bool brightnessSynchronization);
