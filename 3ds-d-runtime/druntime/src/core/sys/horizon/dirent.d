/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly,
              Alex Rønne Petersn
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.dirent;

import core.sys.horizon.config;
public import core.sys.horizon.sys.types; // for ino_t

// limits
import core.stdc.limits : NAME_MAX;


version (Horizon):
extern (C):
nothrow:
@nogc:

//
// Required
//
/*
struct dirent
{
    char[] d_name;
}
*/

struct dirent
{
  ino_t d_ino;
  char d_type;
  char[NAME_MAX + 1] d_name;
}

/*
DIR

int     closedir(DIR*);
DIR*    opendir(const scope char*);
dirent* readdir(DIR*);
void    rewinddir(DIR*);
*/

private struct DIR_ITER
{ // iosupport.h
  int device;
  void* dirStruct;
}

struct DIR
{
  c_long position;
  DIR_ITER* dirData;
  dirent fileData;
}

int closedir(DIR*);
DIR* opendir(const scope char*);
dirent* readdir(DIR*);
void rewinddir(DIR*);

enum
{
  DT_UNKNOWN = 0,
  DT_FIFO = 1,
  DT_CHR = 2,
  DT_DIR = 4,
  DT_BLK = 6,
  DT_REG = 8,
  DT_LNK = 10,
  DT_SOCK = 12,
  DT_WHT = 14
}

//
// Thread-Safe Functions (TSF)
//
/*
int readdir_r(DIR*, dirent*, dirent**);
*/

int readdir_r(DIR*, dirent*, dirent**);

//
// XOpen (XSI)
//
/*
void   seekdir(DIR*, c_long);
c_long telldir(DIR*);
*/

void seekdir(DIR*, c_long);
c_long telldir(DIR*);
