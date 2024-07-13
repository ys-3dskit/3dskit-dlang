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
module core.sys.horizon.sys.stat;

import core.sys.horizon.config;
import core.stdc.stdint;
import core.sys.horizon.time;     // for timespec
public import core.sys.horizon.sys.types; // for off_t, mode_t

import std.conv : octal; // for defining octal literals

version (Horizon):
extern (C) nothrow @nogc:

//
// Required
//
/*
struct stat
{
    dev_t   st_dev;
    ino_t   st_ino;
    mode_t  st_mode;
    nlink_t st_nlink;
    uid_t   st_uid;
    gid_t   st_gid;
    off_t   st_size;
    time_t  st_atime;
    time_t  st_mtime;
    time_t  st_ctime;
}

S_ISUID
S_ISGID
S_ISVTX

S_TYPEISMQ(buf)
S_TYPEISSEM(buf)
S_TYPEISSHM(buf)
 */

struct stat_t
{
  dev_t st_dev;
  ino_t st_ino;
  mode_t st_mode;
  nlink_t st_nlink;
  uid_t st_uid;
  gid_t st_gid;
  dev_t st_rdev;
  off_t st_size;
  timespec st_atim;
  timespec st_mtim;
  timespec st_ctim;
  c_long[2] st_spare4;
}

/*
S_IRWXU
    S_IRUSR
    S_IWUSR
    S_IXUSR
S_IRWXG
    S_IRGRP
    S_IWGRP
    S_IXGRP
S_IRWXO
    S_IROTH
    S_IWOTH
    S_IXOTH

S_ISBLK(m)
S_ISCHR(m)
S_ISDIR(m)
S_ISFIFO(m)
S_ISREG(m)
S_ISLNK(m)
S_ISSOCK(m)
 */

enum S_IRUSR = octal!400;
enum S_IWUSR = octal!200;
enum S_IXUSR = octal!100;
enum S_IRWXU = S_IRUSR | S_IWUSR | S_IXUSR;

enum S_IRGRP = octal!40;
enum S_IWGRP = octal!20;
enum S_IXGRP = octal!10;
enum S_IRWXG = S_IRGRP | S_IWGRP | S_IXGRP;

enum S_IROTH = octal!4;
enum S_IWOTH = octal!2;
enum S_IXOTH = octal!1;
enum S_IRWXO = S_IROTH | S_IWOTH | S_IXOTH;

extern (D) // macros
{
  // impl
  private bool S_ISTYPE(uint mask)(mode_t mode)
  {
    return (mode & S_IFMT) == mask;
  }

  alias S_ISBLK  = S_ISTYPE!S_IFBLK;
  alias S_ISCHR  = S_ISTYPE!S_IFCHR;
  alias S_ISDIR  = S_ISTYPE!S_IFDIR;
  alias S_ISFIFO = S_ISTYPE!S_IFIFO;
  alias S_ISREG  = S_ISTYPE!S_IFREG;
  alias S_ISLNK  = S_ISTYPE!S_IFLNK;
  alias S_ISSOCK = S_ISTYPE!S_IFSOCK;
}

int utimensat(int, const char*, ref const(timespec)[2], int);
int futimens(int, ref const(timespec)[2]);

/*
int    chmod(const scope char*, mode_t);
int    fchmod(int, mode_t);
int    fstat(int, stat*);
int    lstat(const scope char*, stat*);
int    mkdir(const scope char*, mode_t);
int    mkfifo(const scope char*, mode_t);
int    stat(const scope char*, stat*);
mode_t umask(mode_t);
*/

int    chmod(const scope char*, mode_t);
int    fchmod(int, mode_t);
//int    fstat(int, stat_t*);
//int    lstat(const scope char*, stat_t*);
int    mkdir(const scope char*, mode_t);
int    mkfifo(const scope char*, mode_t);
//int    stat(const scope char*, stat_t*);
mode_t umask(mode_t);

int fstat(int __fd, stat_t* __sbuf) @trusted;
int lstat(const scope char* __path, stat_t* __sbuf);
int stat(const scope char* __path, stat_t* __sbuf);

//
// Typed Memory Objects (TYM)
//
/*
S_TYPEISTMO(buf)
*/

//
// XOpen (XSI)
//
/*
S_IFMT
S_IFBLK
S_IFCHR
S_IFIFO
S_IFREG
S_IFDIR
S_IFLNK
S_IFSOCK
*/

enum S_IFMT   = octal!170_000; /* type of file */
enum S_IFDIR  = octal! 40_000; /* directory */
enum S_IFCHR  = octal! 20_000; /* character special */
enum S_IFBLK  = octal! 60_000; /* block special */
enum S_IFREG  = octal!100_000; /* regular */
enum S_IFLNK  = octal!120_000; /* symbolic link */
enum S_IFSOCK = octal!140_000; /* socket */
enum S_IFIFO  = octal! 10_000; /* fifo */

/*
int mknod(const scope char*, mode_t, dev_t);
*/

int mknod(const scope char* __path, mode_t __mode, dev_t __dev);
