/**
 * @file error.h
 * @brief Error applet.
 */

extern (C):

// CFG_Language

enum
{
    ERROR_LANGUAGE_FLAG = 0x100, ///<??-Unknown flag
    ERROR_WORD_WRAP_FLAG = 0x200 ///<??-Unknown flag
}

///< Type of Error applet to be called

enum errorType
{
    ERROR_CODE = 0, ///< Displays the infrastructure communications-related error message corresponding to the error code.
    ERROR_TEXT = 1, ///< Displays text passed to this applet.
    ERROR_EULA = 2, ///< Displays the EULA
    ERROR_TYPE_EULA_FIRST_BOOT = 3, ///< Use prohibited.
    ERROR_TYPE_EULA_DRAW_ONLY = 4, ///< Use prohibited.
    ERROR_TYPE_AGREE = 5, ///< Use prohibited.
    ERROR_CODE_LANGUAGE = ERROR_CODE | .ERROR_LANGUAGE_FLAG, ///< Displays a network error message in a specified language.
    ERROR_TEXT_LANGUAGE = ERROR_TEXT | .ERROR_LANGUAGE_FLAG, ///< Displays text passed to this applet in a specified language.
    ERROR_EULA_LANGUAGE = ERROR_EULA | .ERROR_LANGUAGE_FLAG, ///< Displays EULA in a specified language.
    ERROR_TEXT_WORD_WRAP = ERROR_TEXT | .ERROR_WORD_WRAP_FLAG, ///< Displays the custom error message passed to this applet with automatic line wrapping
    ERROR_TEXT_LANGUAGE_WORD_WRAP = ERROR_TEXT | .ERROR_LANGUAGE_FLAG | .ERROR_WORD_WRAP_FLAG ///< Displays the custom error message with automatic line wrapping and in the specified language.
}

///< Flags for the Upper Screen.Does nothing even if specified.

enum errorScreenFlag
{
    ERROR_NORMAL = 0,
    ERROR_STEREO = 1
}

///< Return code of the Error module.Use UNKNOWN for simple apps.

enum errorReturnCode
{
    ERROR_UNKNOWN = -1,
    ERROR_NONE = 0,
    ERROR_SUCCESS = 1,
    ERROR_NOT_SUPPORTED = 2,
    ERROR_HOME_BUTTON = 10,
    ERROR_SOFTWARE_RESET = 11,
    ERROR_POWER_BUTTON = 12
}

///< Structure to be passed to the applet.Shouldn't be modified directly.

struct errorConf
{
    errorType type;
    int errorCode;
    errorScreenFlag upperScreenFlag;
    ushort useLanguage;
    ushort[1900] Text;
    bool homeButton;
    bool softwareReset;
    bool appJump;
    errorReturnCode returnCode;
    ushort eulaVersion;
}

/**
* @brief Init the error applet.
* @param err Pointer to errorConf.
* @param type errorType Type of error.
* @param lang CFG_Language Lang of error.
*/
void errorInit (errorConf* err, errorType type, CFG_Language lang);
/**
* @brief Sets error code to display.
* @param err Pointer to errorConf.
* @param error Error-code to display.
*/
void errorCode (errorConf* err, int error);
/**
* @brief Sets error text to display.
* @param err Pointer to errorConf.
* @param text Error-text to display.
*/
void errorText (errorConf* err, const(char)* text);
/**
* @brief Displays the error applet.
* @param err Pointer to errorConf.
*/
void errorDisp (errorConf* err);
