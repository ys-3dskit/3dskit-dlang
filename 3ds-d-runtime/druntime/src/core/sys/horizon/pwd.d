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
module core.sys.horizon.pwd;

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
struct passwd
{
    char*   pw_name;
    uid_t   pw_uid;
    gid_t   pw_gid;
    char*   pw_dir;
    char*   pw_shell;
}

passwd* getpwnam(const scope char*);
passwd* getpwuid(uid_t);
*/

struct passwd
{
  char* pw_name; /* user name */
  char* pw_passwd; /* encrypted password */
  uid_t pw_uid; /* user uid */
  gid_t pw_gid; /* user gid */
  char* pw_comment; /* comment */
  char* pw_gecos; /* Honeywell login info */
  char* pw_dir; /* home directory */
  char* pw_shell; /* default shell */
}

passwd* getpwnam(const scope char*);
passwd* getpwuid(uid_t);

//
// Thread-Safe Functions (TSF)
//
/*
int getpwnam_r(const scope char*, passwd*, char*, size_t, passwd**);
int getpwuid_r(uid_t, passwd*, char*, size_t, passwd**);
*/

int getpwnam_r(const scope char*, passwd*, char*, size_t, passwd**);
int getpwuid_r(uid_t, passwd*, char*, size_t, passwd**);

//
// XOpen (XSI)
//
/*
void    endpwent();
passwd* getpwent();
void    setpwent();
*/

void    endpwent();
passwd* getpwent();
void    setpwent();
