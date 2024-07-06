/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009, Sönke Ludwig 2013.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly, Alex Rønne Petersen, Sönke Ludwig
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.grp;

import core.sys.horizon.config;
public import core.sys.horizon.sys.types; // for gid_t, uid_t

version (Horizon):
extern (C):
nothrow:
@nogc:

//
// Required
//
/*
struct group
{
    char*   gr_name;
    char*   gr_passwd;
    gid_t   gr_gid;
    char**  gr_mem;
}

group* getgrnam(const scope char*);
group* getgrgid(gid_t);
*/

struct group
{
  char* gr_name; /* group name */
  char* gr_passwd; /* group password */
  gid_t gr_gid; /* group id */
  char** gr_mem; /* group members */
}

group* getgrnam(const scope char*);
group* getgrgid(gid_t);

//
// Thread-Safe Functions (TSF)
//
/*
int getgrnam_r(const scope char*, group*, char*, size_t, group**);
int getgrgid_r(gid_t, group*, char*, size_t, group**);
*/

int getgrnam_r(const scope char*, group*, char*, size_t, group**);
int getgrgid_r(gid_t, group*, char*, size_t, group**);

//
// XOpen (XSI)
//
/*
struct group  *getgrent(void);
void           endgrent(void);
void           setgrent(void);
*/

group* getgrent();
@trusted void endgrent();
@trusted void setgrent();
