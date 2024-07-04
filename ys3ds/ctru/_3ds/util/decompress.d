module ys3ds.ctru._3ds.util.decompress;

/**
 * @file decompress.h
 * @brief Decompression functions.
 */

//import core.stdc.config;
//import core.sys.posix.sys.types;

import ys3ds.ctru._3ds.types;

extern (C):

/** @brief Compression types */
enum decompressType
{
    DECOMPRESS_DUMMY = 0x00, ///< Dummy compression
    DECOMPRESS_LZSS = 0x10, ///< LZSS/LZ10 compression
    DECOMPRESS_LZ10 = 0x10, ///< LZSS/LZ10 compression
    DECOMPRESS_LZ11 = 0x11, ///< LZ11 compression
    DECOMPRESS_HUFF1 = 0x21, ///< Huffman compression with 1-bit data
    DECOMPRESS_HUFF2 = 0x22, ///< Huffman compression with 2-bit data
    DECOMPRESS_HUFF3 = 0x23, ///< Huffman compression with 3-bit data
    DECOMPRESS_HUFF4 = 0x24, ///< Huffman compression with 4-bit data
    DECOMPRESS_HUFF5 = 0x25, ///< Huffman compression with 5-bit data
    DECOMPRESS_HUFF6 = 0x26, ///< Huffman compression with 6-bit data
    DECOMPRESS_HUFF7 = 0x27, ///< Huffman compression with 7-bit data
    DECOMPRESS_HUFF8 = 0x28, ///< Huffman compression with 8-bit data
    DECOMPRESS_HUFF = 0x28, ///< Huffman compression with 8-bit data
    DECOMPRESS_RLE = 0x30 ///< Run-length encoding compression
}

/** @brief I/O vector */
struct decompressIOVec
{
    void* data; ///< I/O buffer
    size_t size; ///< Buffer size
}

/** @brief Data callback */
alias decompressCallback = c_long function (
    void* userdata,
    void* buffer,
    size_t size);

/** @brief Decompression callback for file descriptors
 *  @param[in] userdata Address of file descriptor
 *  @param[in] buffer   Buffer to write into
 *  @param[in] size     Size to read from file descriptor
 *  @returns Number of bytes read
 */
ssize_t decompressCallback_FD (void* userdata, void* buffer, size_t size);

/** @brief Decompression callback for stdio FILE*
 *  @param[in] userdata FILE*
 *  @param[in] buffer   Buffer to write into
 *  @param[in] size     Size to read from file descriptor
 *  @returns Number of bytes read
 */
ssize_t decompressCallback_Stdio (void* userdata, void* buffer, size_t size);

/** @brief Decode decompression header
 *  @param[out] type     Decompression type
 *  @param[out] size     Decompressed size
 *  @param[in]  callback Data callback (see decompressV())
 *  @param[in]  userdata User data passed to callback (see decompressV())
 *  @param[in]  insize   Size of userdata (see decompressV())
 *  @returns Bytes consumed
 *  @retval -1 error
 */
ssize_t decompressHeader (
    decompressType* type,
    size_t* size,
    decompressCallback callback,
    void* userdata,
    size_t insize);

/** @brief Decompress data
 *  @param[in] iov      Output vector
 *  @param[in] iovcnt   Number of buffers
 *  @param[in] callback Data callback (see note)
 *  @param[in] userdata User data passed to callback (see note)
 *  @param[in] insize   Size of userdata (see note)
 *  @returns Whether succeeded
 *
 *  @note If callback is null, userdata is a pointer to memory to read from,
 *        and insize is the size of that data. If callback is not null,
 *        userdata is passed to callback to fetch more data, and insize is
 *        unused.
 */
bool decompressV (
    const(decompressIOVec)* iov,
    size_t iovcnt,
    decompressCallback callback,
    void* userdata,
    size_t insize);

/** @brief Decompress data
 *  @param[in] output   Output buffer
 *  @param[in] size     Output size limit
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompress (
    void* output,
    size_t size,
    decompressCallback callback,
    void* userdata,
    size_t insize)
{
  decompressIOVec iov;
  iov.data = output;
  iov.size = size;

  return decompressV(&iov, 1, callback, userdata, insize);
}

/** @brief Decompress LZSS/LZ10
 *  @param[in] iov      Output vector
 *  @param[in] iovcnt   Number of buffers
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompressV_LZSS (
    const(decompressIOVec)* iov,
    size_t iovcnt,
    decompressCallback callback,
    void* userdata,
    size_t insize);

/** @brief Decompress LZSS/LZ10
 *  @param[in] output   Output buffer
 *  @param[in] size     Output size limit
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompress_LZSS (
    void* output,
    size_t size,
    decompressCallback callback,
    void* userdata,
    size_t insize)
{
  decompressIOVec iov;
  iov.data = output;
  iov.size = size;

  return decompressV_LZSS(&iov, 1, callback, userdata, insize);
}

/** @brief Decompress LZ11
 *  @param[in] iov      Output vector
 *  @param[in] iovcnt   Number of buffers
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompressV_LZ11 (
    const(decompressIOVec)* iov,
    size_t iovcnt,
    decompressCallback callback,
    void* userdata,
    size_t insize);

/** @brief Decompress LZ11
 *  @param[in] output   Output buffer
 *  @param[in] size     Output size limit
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompress_LZ11 (
    void* output,
    size_t size,
    decompressCallback callback,
    void* userdata,
    size_t insize)
{
  decompressIOVec iov;
  iov.data = output;
  iov.size = size;

  return decompressV_LZ11(&iov, 1, callback, userdata, insize);
}

/** @brief Decompress Huffman
 *  @param[in] bits     Data size in bits (usually 4 or 8)
 *  @param[in] iov      Output vector
 *  @param[in] iovcnt   Number of buffers
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompressV_Huff (
    size_t bits,
    const(decompressIOVec)* iov,
    size_t iovcnt,
    decompressCallback callback,
    void* userdata,
    size_t insize);

/** @brief Decompress Huffman
 *  @param[in] bits     Data size in bits (usually 4 or 8)
 *  @param[in] output   Output buffer
 *  @param[in] size     Output size limit
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompress_Huff (
    size_t bits,
    void* output,
    size_t size,
    decompressCallback callback,
    void* userdata,
    size_t insize)
{
  decompressIOVec iov;
  iov.data = output;
  iov.size = size;

  return decompressV_Huff(bits, &iov, 1, callback, userdata, insize);
}

/** @brief Decompress run-length encoding
 *  @param[in] iov      Output vector
 *  @param[in] iovcnt   Number of buffers
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompressV_RLE (
    const(decompressIOVec)* iov,
    size_t iovcnt,
    decompressCallback callback,
    void* userdata,
    size_t insize);

/** @brief Decompress run-length encoding
 *  @param[in] output   Output buffer
 *  @param[in] size     Output size limit
 *  @param[in] callback Data callback (see decompressV())
 *  @param[in] userdata User data passed to callback (see decompressV())
 *  @param[in] insize   Size of userdata (see decompressV())
 *  @returns Whether succeeded
 */
bool decompress_RLE (
    void* output,
    size_t size,
    decompressCallback callback,
    void* userdata,
    size_t insize)
{
  decompressIOVec iov;
  iov.data = output;
  iov.size = size;

  return decompressV_RLE(&iov, 1, callback, userdata, insize);
}

