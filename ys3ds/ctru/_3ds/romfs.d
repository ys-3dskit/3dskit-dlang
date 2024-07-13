/**
 * @file romfs.h
 * @brief RomFS driver.
 */

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.services.fs;

extern (C) @nogc nothrow:

/// RomFS header.
struct romfs_header
{
    uint headerSize; ///< Size of the header.
    uint dirHashTableOff; ///< Offset of the directory hash table.
    uint dirHashTableSize; ///< Size of the directory hash table.
    uint dirTableOff; ///< Offset of the directory table.
    uint dirTableSize; ///< Size of the directory table.
    uint fileHashTableOff; ///< Offset of the file hash table.
    uint fileHashTableSize; ///< Size of the file hash table.
    uint fileTableOff; ///< Offset of the file table.
    uint fileTableSize; ///< Size of the file table.
    uint fileDataOff; ///< Offset of the file data.
}

/// RomFS directory.
struct romfs_dir
{
    uint parent; ///< Offset of the parent directory.
    uint sibling; ///< Offset of the next sibling directory.
    uint childDir; ///< Offset of the first child directory.
    uint childFile; ///< Offset of the first file.
    uint nextHash; ///< Directory hash table pointer.
    uint nameLen; ///< Name length.
    ushort[] name; ///< Name. (UTF-16)
}

/// RomFS file.
struct romfs_file
{
    uint parent; ///< Offset of the parent directory.
    uint sibling; ///< Offset of the next sibling file.
    ulong dataOff; ///< Offset of the file's data.
    ulong dataSize; ///< Length of the file's data.
    uint nextHash; ///< File hash table pointer.
    uint nameLen; ///< Name length.
    ushort[] name; ///< Name. (UTF-16)
}

/**
 * @brief Mounts the Application's RomFS.
 * @param name Device mount name.
 * @remark This function is intended to be used to access one's own RomFS.
 *         If the application is running as 3DSX, it mounts the embedded RomFS section inside the 3DSX.
 *         If on the other hand it's an NCCH, it behaves identically to \ref romfsMountFromCurrentProcess.
 */
Result romfsMountSelf (const(char)* name);

/**
 * @brief Mounts RomFS from an open file.
 * @param fd FSFILE handle of the RomFS image.
 * @param offset Offset of the RomFS within the file.
 * @param name Device mount name.
 */
Result romfsMountFromFile (Handle fd, uint offset, const(char)* name);

/**
 * @brief Mounts RomFS using the current process host program RomFS.
 * @param name Device mount name.
 */
Result romfsMountFromCurrentProcess (const(char)* name);

/**
 * @brief Mounts RomFS from the specified title.
 * @param tid Title ID
 * @param mediatype Mediatype
 * @param name Device mount name.
 */
Result romfsMountFromTitle (ulong tid, FS_MediaType mediatype, const(char)* name);

/// Unmounts the RomFS device.
Result romfsUnmount (const(char)* name);

/// Wrapper for \ref romfsMountSelf with the default "romfs" device name.
extern(D) Result romfsInit ()
{
  return romfsMountSelf("romfs");
}

/// Wrapper for \ref romfsUnmount with the default "romfs" device name.
extern(D) Result romfsExit ()
{
  return romfsUnmount("romfs");
}
