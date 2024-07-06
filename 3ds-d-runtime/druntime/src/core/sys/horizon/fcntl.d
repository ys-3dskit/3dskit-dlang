/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly, Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.fcntl;

import core.sys.horizon.config;
import core.stdc.stdint;
public import core.sys.horizon.sys.types; // for off_t, mode_t
public import core.sys.horizon.sys.stat;  // for S_IFMT, etc.

version (ARM)     version = ARM_Any;

version (Horizon):
extern (C):

nothrow:
@nogc:

//
// Required
//
/*
F_DUPFD
F_GETFD
F_SETFD
F_GETFL
F_SETFL
F_GETLK
F_SETLK
F_SETLKW
F_GETOWN
F_SETOWN

FD_CLOEXEC

F_RDLCK
F_UNLCK
F_WRLCK

O_CREAT
O_EXCL
O_NOCTTY
O_TRUNC

O_APPEND
O_DSYNC
O_NONBLOCK
O_RSYNC
O_SYNC

O_ACCMODE
O_RDONLY
O_RDWR
O_WRONLY

struct flock
{
    short   l_type;
    short   l_whence;
    off_t   l_start;
    off_t   l_len;
    pid_t   l_pid;
}
*/

enum F_DUPFD = 0;
enum F_GETFD = 1;
enum F_SETFD = 2;
enum F_GETFL = 3;
enum F_SETFL = 4;

enum F_GETLK = 7;
enum F_SETLK = 8;
enum F_SETLKW = 9;

enum F_GETOWN = 5;
enum F_SETOWN = 6;

enum FD_CLOEXEC = 1;

enum F_RDLCK = 1;
enum F_WRLCK = 2;
enum F_UNLCK = 3;

enum O_CREAT = 0x200;
enum O_EXCL = 0x800;
enum O_NOCTTY = 0x8000;
enum O_TRUNC = 0x400;

enum O_APPEND = 0x8;
enum O_DSYNC = O_SYNC;
enum O_NONBLOCK = 0x4000;
enum O_RSYNC = O_SYNC;
enum O_SYNC = 0x2000;

enum O_ACCMODE = O_RDONLY | O_WRONLY | O_RDWR;
enum O_RDONLY = 0;
enum O_RDWR = 2;
enum O_WRONLY = 1;

struct flock
{
  short l_type; /* F_RDLCK, F_WRLCK, or F_UNLCK */
  short l_whence; /* flag to choose starting offset */
  long l_start; /* relative offset, in bytes */
  long l_len; /* length, in bytes; 0 means lock to EOF */
  short l_pid; /* returned with F_GETLK */
  short l_xxx; /* reserved for future use */
}

/*
int creat(const scope char*, mode_t);
int fcntl(int, int, ...);
int open(const scope char*, int, ...);
*/

int creat(const scope char*, mode_t);
int fcntl(int, int, ...);
int open(const scope char*, int, ...);

//int creat(const scope char*, mode_t);
//int fcntl(int, int, ...);
//int open(const scope char*, int, ...);

// Generic Posix fallocate
//int posix_fallocate(int, off_t, off_t);

//
// Advisory Information (ADV)
//
/*
POSIX_FADV_NORMAL
POSIX_FADV_SEQUENTIAL
POSIX_FADV_RANDOM
POSIX_FADV_WILLNEED
POSIX_FADV_DONTNEED
POSIX_FADV_NOREUSE

int posix_fadvise(int, off_t, off_t, int);
*/
