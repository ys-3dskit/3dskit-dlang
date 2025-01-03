/**
 * @file utf.h
 * @brief UTF conversion functions.
 */

//import core.sys.posix.sys.types;

import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

/** Convert a UTF-8 sequence into a UTF-32 codepoint
 *
 *  @param[out] out Output codepoint
 *  @param[in]  in  Input sequence
 *
 *  @returns number of input code units consumed
 *  @returns -1 for error
 */
ssize_t decode_utf8 (uint* out_, const(ubyte)* in_);

/** Convert a UTF-16 sequence into a UTF-32 codepoint
 *
 *  @param[out] out Output codepoint
 *  @param[in]  in  Input sequence
 *
 *  @returns number of input code units consumed
 *  @returns -1 for error
 */
ssize_t decode_utf16 (uint* out_, const(ushort)* in_);

/** Convert a UTF-32 codepoint into a UTF-8 sequence
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input codepoint
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out must be able to store 4 code units
 */
ssize_t encode_utf8 (ubyte* out_, uint in_);

/** Convert a UTF-32 codepoint into a UTF-16 sequence
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input codepoint
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out must be able to store 2 code units
 */
ssize_t encode_utf16 (ushort* out_, uint in_);

/** Convert a UTF-8 sequence into a UTF-16 sequence
 *
 *  Fills the output buffer up to \a len code units.
 *  Returns the number of code units that the input would produce;
 *  if it returns greater than \a len, the output has been
 *  truncated.
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input sequence (null-terminated)
 *  @param[in]  len Output length
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out is not null-terminated
 */
ssize_t utf8_to_utf16 (ushort* out_, const(ubyte)* in_, size_t len);

/** Convert a UTF-8 sequence into a UTF-32 sequence
 *
 *  Fills the output buffer up to \a len code units.
 *  Returns the number of code units that the input would produce;
 *  if it returns greater than \a len, the output has been
 *  truncated.
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input sequence (null-terminated)
 *  @param[in]  len Output length
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out is not null-terminated
 */
ssize_t utf8_to_utf32 (uint* out_, const(ubyte)* in_, size_t len);

/** Convert a UTF-16 sequence into a UTF-8 sequence
 *
 *  Fills the output buffer up to \a len code units.
 *  Returns the number of code units that the input would produce;
 *  if it returns greater than \a len, the output has been
 *  truncated.
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input sequence (null-terminated)
 *  @param[in]  len Output length
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out is not null-terminated
 */
ssize_t utf16_to_utf8 (ubyte* out_, const(ushort)* in_, size_t len);

/** Convert a UTF-16 sequence into a UTF-32 sequence
 *
 *  Fills the output buffer up to \a len code units.
 *  Returns the number of code units that the input would produce;
 *  if it returns greater than \a len, the output has been
 *  truncated.
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input sequence (null-terminated)
 *  @param[in]  len Output length
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out is not null-terminated
 */
ssize_t utf16_to_utf32 (uint* out_, const(ushort)* in_, size_t len);

/** Convert a UTF-32 sequence into a UTF-8 sequence
 *
 *  Fills the output buffer up to \a len code units.
 *  Returns the number of code units that the input would produce;
 *  if it returns greater than \a len, the output has been
 *  truncated.
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input sequence (null-terminated)
 *  @param[in]  len Output length
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out is not null-terminated
 */
ssize_t utf32_to_utf8 (ubyte* out_, const(uint)* in_, size_t len);

/** Convert a UTF-32 sequence into a UTF-16 sequence
 *
 *  @param[out] out Output sequence
 *  @param[in]  in  Input sequence (null-terminated)
 *  @param[in]  len Output length
 *
 *  @returns number of output code units produced
 *  @returns -1 for error
 *
 *  @note \a out is not null-terminated
 */
ssize_t utf32_to_utf16 (ushort* out_, const(uint)* in_, size_t len);
