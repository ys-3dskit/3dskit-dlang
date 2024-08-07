/**
 * @file swkbd.h
 * @brief Software keyboard applet.
 */

import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

/// Keyboard types.
enum SwkbdType
{
    SWKBD_TYPE_NORMAL = 0, ///< Normal keyboard with several pages (QWERTY/accents/symbol/mobile)
    SWKBD_TYPE_QWERTY = 1, ///< QWERTY keyboard only.
    SWKBD_TYPE_NUMPAD = 2, ///< Number pad.
    SWKBD_TYPE_WESTERN = 3 ///< On JPN systems, a text keyboard without Japanese input capabilities, otherwise same as SWKBD_TYPE_NORMAL.
}

/// Accepted input types.
enum SwkbdValidInput
{
    SWKBD_ANYTHING = 0, ///< All inputs are accepted.
    SWKBD_NOTEMPTY = 1, ///< Empty inputs are not accepted.
    SWKBD_NOTEMPTY_NOTBLANK = 2, ///< Empty or blank inputs (consisting solely of whitespace) are not accepted.
    SWKBD_NOTBLANK_NOTEMPTY = SWKBD_NOTEMPTY_NOTBLANK,
    SWKBD_NOTBLANK = 3, ///< Blank inputs (consisting solely of whitespace) are not accepted, but empty inputs are.
    SWKBD_FIXEDLEN = 4 ///< The input must have a fixed length (specified by maxTextLength in swkbdInit).
}

/// Keyboard dialog buttons.
enum SwkbdButton
{
    SWKBD_BUTTON_LEFT = 0, ///< Left button (usually Cancel)
    SWKBD_BUTTON_MIDDLE = 1, ///< Middle button (usually I Forgot)
    SWKBD_BUTTON_RIGHT = 2, ///< Right button (usually OK)
    SWKBD_BUTTON_CONFIRM = SWKBD_BUTTON_RIGHT,
    SWKBD_BUTTON_NONE = 3 ///< No button (returned by swkbdInputText in special cases)
}

/// Keyboard password modes.
enum SwkbdPasswordMode
{
    SWKBD_PASSWORD_NONE = 0, ///< Characters are not concealed.
    SWKBD_PASSWORD_HIDE = 1, ///< Characters are concealed immediately.
    SWKBD_PASSWORD_HIDE_DELAY = 2 ///< Characters are concealed a second after they've been typed.
}

/// Keyboard input filtering flags.
enum
{
    SWKBD_FILTER_DIGITS = BIT(0), ///< Disallow the use of more than a certain number of digits (0 or more)
    SWKBD_FILTER_AT = BIT(1), ///< Disallow the use of the @ sign.
    SWKBD_FILTER_PERCENT = BIT(2), ///< Disallow the use of the % sign.
    SWKBD_FILTER_BACKSLASH = BIT(3), ///< Disallow the use of the \ sign.
    SWKBD_FILTER_PROFANITY = BIT(4), ///< Disallow profanity using Nintendo's profanity filter.
    SWKBD_FILTER_CALLBACK = BIT(5) ///< Use a callback in order to check the input.
}

/// Keyboard features.
enum
{
    SWKBD_PARENTAL = BIT(0), ///< Parental PIN mode.
    SWKBD_DARKEN_TOP_SCREEN = BIT(1), ///< Darken the top screen when the keyboard is shown.
    SWKBD_PREDICTIVE_INPUT = BIT(2), ///< Enable predictive input (necessary for Kanji input in JPN systems).
    SWKBD_MULTILINE = BIT(3), ///< Enable multiline input.
    SWKBD_FIXED_WIDTH = BIT(4), ///< Enable fixed-width mode.
    SWKBD_ALLOW_HOME = BIT(5), ///< Allow the usage of the HOME button.
    SWKBD_ALLOW_RESET = BIT(6), ///< Allow the usage of a software-reset combination.
    SWKBD_ALLOW_POWER = BIT(7), ///< Allow the usage of the POWER button.
    SWKBD_DEFAULT_QWERTY = BIT(9) ///< Default to the QWERTY page when the keyboard is shown.
}

/// Keyboard filter callback return values.
enum SwkbdCallbackResult
{
    SWKBD_CALLBACK_OK = 0, ///< Specifies that the input is valid.
    SWKBD_CALLBACK_CLOSE = 1, ///< Displays an error message, then closes the keyboard.
    SWKBD_CALLBACK_CONTINUE = 2 ///< Displays an error message and continues displaying the keyboard.
}

/// Keyboard return values.
enum SwkbdResult
{
    SWKBD_NONE = -1, ///< Dummy/unused.
    SWKBD_INVALID_INPUT = -2, ///< Invalid parameters to swkbd.
    SWKBD_OUTOFMEM = -3, ///< Out of memory.

    SWKBD_D0_CLICK = 0, ///< The button was clicked in 1-button dialogs.
    SWKBD_D1_CLICK0 = 1, ///< The left button was clicked in 2-button dialogs.
    SWKBD_D1_CLICK1 = 2, ///< The right button was clicked in 2-button dialogs.
    SWKBD_D2_CLICK0 = 3, ///< The left button was clicked in 3-button dialogs.
    SWKBD_D2_CLICK1 = 4, ///< The middle button was clicked in 3-button dialogs.
    SWKBD_D2_CLICK2 = 5, ///< The right button was clicked in 3-button dialogs.

    SWKBD_HOMEPRESSED = 10, ///< The HOME button was pressed.
    SWKBD_RESETPRESSED = 11, ///< The soft-reset key combination was pressed.
    SWKBD_POWERPRESSED = 12, ///< The POWER button was pressed.

    SWKBD_PARENTAL_OK = 20, ///< The parental PIN was verified successfully.
    SWKBD_PARENTAL_FAIL = 21, ///< The parental PIN was incorrect.

    SWKBD_BANNED_INPUT = 30 ///< The filter callback returned SWKBD_CALLBACK_CLOSE.
}

/// Maximum dictionary word length, in UTF-16 code units.
enum SWKBD_MAX_WORD_LEN = 40;
/// Maximum button text length, in UTF-16 code units.
enum SWKBD_MAX_BUTTON_TEXT_LEN = 16;
/// Maximum hint text length, in UTF-16 code units.
enum SWKBD_MAX_HINT_TEXT_LEN = 64;
/// Maximum filter callback error message length, in UTF-16 code units.
enum SWKBD_MAX_CALLBACK_MSG_LEN = 256;

/// Keyboard dictionary word for predictive input.
struct SwkbdDictWord
{
    ushort[41] reading; ///< Reading of the word (that is, the string that needs to be typed).
    ushort[41] word; ///< Spelling of the word.
    ubyte language; ///< Language the word applies to.
    bool all_languages; ///< Specifies if the word applies to all languages.
}

/// Keyboard filter callback function.
alias SwkbdCallbackFn = SwkbdCallbackResult function (void* user, const(char*)* ppMessage, const(char)* text, size_t textlen);
/// Keyboard status data.
struct SwkbdStatusData
{
    uint[0x11] data;
}

/// Keyboard predictive input learning data.
struct SwkbdLearningData
{
    uint[0x291B] data;
}

/// Internal libctru book-keeping structure for software keyboards.
struct SwkbdExtra
{
    const(char)* initial_text;
    const(SwkbdDictWord)* dict;
    SwkbdStatusData* status_data;
    SwkbdLearningData* learning_data;
    SwkbdCallbackFn callback;
    void* callback_user;
}

/// Software keyboard parameter structure, it shouldn't be modified directly.
struct SwkbdState
{
    int type;
    int num_buttons_m1;
    int valid_input;
    int password_mode;
    int is_parental_screen;
    int darken_top_screen;
    uint filter_flags;
    uint save_state_flags;
    ushort max_text_len;
    ushort dict_word_count;
    ushort max_digits;
    ushort[1][3] button_text;
    ushort[2] numpad_keys;
    ushort[65] hint_text;
    bool predictive_input;
    bool multiline;
    bool fixed_width;
    bool allow_home;
    bool allow_reset;
    bool allow_power;
    bool unknown; // XX: what is this supposed to do? "communicateWithOtherRegions"
    bool default_qwerty;
    bool[4] button_submits_text;
    ushort language; // XX: not working? supposedly 0 = use system language, CFG_Language+1 = pick language
    int initial_text_offset;
    int dict_offset;
    int initial_status_offset;
    int initial_learning_offset;
    size_t shared_memory_size;
    uint version_;
    SwkbdResult result;
    int status_offset;
    int learning_offset;
    int text_offset;
    ushort text_length;
    int callback_result;
    ushort[257] callback_msg;
    bool skip_at_check;

    union
    {
        ubyte[171] reserved;
        SwkbdExtra extra;
    }
}

/**
 * @brief Initializes software keyboard status.
 * @param swkbd Pointer to swkbd state.
 * @param type Keyboard type.
 * @param numButtons Number of dialog buttons to display (1, 2 or 3).
 * @param maxTextLength Maximum number of UTF-16 code units that input text can have (or -1 to let libctru use a big default).
 */
void swkbdInit (SwkbdState* swkbd, SwkbdType type, int numButtons, int maxTextLength);

/**
 * @brief Configures password mode in a software keyboard.
 * @param swkbd Pointer to swkbd state.
 * @param mode Password mode.
 */
extern(D) void swkbdSetPasswordMode (SwkbdState* swkbd, SwkbdPasswordMode mode)
{
  swkbd.password_mode = mode;
}

/**
 * @brief Configures input validation in a software keyboard.
 * @param swkbd Pointer to swkbd state.
 * @param validInput Specifies which inputs are valid.
 * @param filterFlags Bitmask specifying which characters are disallowed (filtered).
 * @param maxDigits In case digits are disallowed, specifies how many digits are allowed at maximum in input strings (0 completely restricts digit input).
 */
extern(D) void swkbdSetValidation (
    SwkbdState* swkbd,
    SwkbdValidInput validInput,
    uint filterFlags,
    int maxDigits)
{
  swkbd.valid_input = validInput;
  swkbd.filter_flags = filterFlags;
  swkbd.max_digits = cast(ushort) ((filterFlags & SWKBD_FILTER_DIGITS) ? maxDigits : 0);
}

/**
 * @brief Configures what characters will the two bottom keys in a numpad produce.
 * @param swkbd Pointer to swkbd state.
 * @param left Unicode codepoint produced by the leftmost key in the bottom row (0 hides the key).
 * @param left Unicode codepoint produced by the rightmost key in the bottom row (0 hides the key).
 */
extern(D) void swkbdSetNumpadKeys (SwkbdState* swkbd, int left, int right)
{
  swkbd.numpad_keys[0] = cast(ushort) left;
  swkbd.numpad_keys[1] = cast(ushort) right;
}

/**
 * @brief Specifies which special features are enabled in a software keyboard.
 * @param swkbd Pointer to swkbd state.
 * @param features Feature bitmask.
 */
void swkbdSetFeatures (SwkbdState* swkbd, uint features);

/**
 * @brief Sets the hint text of a software keyboard (that is, the help text that is displayed when the textbox is empty).
 * @param swkbd Pointer to swkbd state.
 * @param text Hint text.
 */
void swkbdSetHintText (SwkbdState* swkbd, const(char)* text);

/**
 * @brief Configures a dialog button in a software keyboard.
 * @param swkbd Pointer to swkbd state.
 * @param button Specifies which button to configure.
 * @param text Button text.
 * @param submit Specifies whether pushing the button will submit the text or discard it.
 */
void swkbdSetButton (SwkbdState* swkbd, SwkbdButton button, const(char)* text, bool submit);

/**
 * @brief Sets the initial text that a software keyboard will display on launch.
 * @param swkbd Pointer to swkbd state.
 * @param text Initial text.
 */
void swkbdSetInitialText (SwkbdState* swkbd, const(char)* text);

/**
 * @brief Configures a word in a predictive dictionary for use with a software keyboard.
 * @param word Pointer to dictionary word structure.
 * @param reading Reading of the word, that is, the sequence of characters that need to be typed to trigger the word in the predictive input system.
 * @param text Spelling of the word, that is, the actual characters that will be produced when the user decides to select the word.
 */
void swkbdSetDictWord (SwkbdDictWord* word, const(char)* reading, const(char)* text);

/**
 * @brief Sets the custom word dictionary to be used with the predictive input system of a software keyboard.
 * @param swkbd Pointer to swkbd state.
 * @param dict Pointer to dictionary words.
 * @param wordCount Number of words in the dictionary.
 */
void swkbdSetDictionary (SwkbdState* swkbd, const(SwkbdDictWord)* dict, int wordCount);

/**
 * @brief Configures software keyboard internal status management.
 * @param swkbd Pointer to swkbd state.
 * @param data Pointer to internal status structure (can be in, out or both depending on the other parameters).
 * @param in Specifies whether the data should be read from the structure when the keyboard is launched.
 * @param out Specifies whether the data should be written to the structure when the keyboard is closed.
 */
void swkbdSetStatusData (SwkbdState* swkbd, SwkbdStatusData* data, bool in_, bool out_);

/**
 * @brief Configures software keyboard predictive input learning data management.
 * @param swkbd Pointer to swkbd state.
 * @param data Pointer to learning data structure (can be in, out or both depending on the other parameters).
 * @param in Specifies whether the data should be read from the structure when the keyboard is launched.
 * @param out Specifies whether the data should be written to the structure when the keyboard is closed.
 */
void swkbdSetLearningData (SwkbdState* swkbd, SwkbdLearningData* data, bool in_, bool out_);

/**
 * @brief Configures a custom function to be used to check the validity of input when it is submitted in a software keyboard.
 * @param swkbd Pointer to swkbd state.
 * @param callback Filter callback function.
 * @param user Custom data to be passed to the callback function.
 */
void swkbdSetFilterCallback (SwkbdState* swkbd, SwkbdCallbackFn callback, void* user);

/**
 * @brief Launches a software keyboard in order to input text.
 * @param swkbd Pointer to swkbd state.
 * @param buf Pointer to output buffer which will hold the inputted text.
 * @param bufsize Maximum number of UTF-8 code units that the buffer can hold (including null terminator).
 * @return The identifier of the dialog button that was pressed, or SWKBD_BUTTON_NONE if a different condition was triggered - in that case use swkbdGetResult to check the condition.
 */
SwkbdButton swkbdInputText (SwkbdState* swkbd, char* buf, size_t bufsize);

/**
 * @brief Retrieves the result condition of a software keyboard after it has been used.
 * @param swkbd Pointer to swkbd state.
 * @return The result value.
 */
extern(D) SwkbdResult swkbdGetResult (SwkbdState* swkbd)
{
  return swkbd.result;
}
