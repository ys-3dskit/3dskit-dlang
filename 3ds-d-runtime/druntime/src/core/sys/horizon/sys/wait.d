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
module core.sys.horizon.sys.wait;

import core.sys.horizon.config;
public import core.sys.horizon.sys.types; // for id_t, pid_t
public import core.sys.horizon.signal;    // for siginfo_t (XSI)
//public import core.sys.posix.resource; // for rusage (XSI)

version (Horizon):
extern (C) nothrow @nogc:

//
// Required
//
/*
WNOHANG
WUNTRACED
*/

enum WNOHANG = 1;
enum WUNTRACED = 2;

/*
WEXITSTATUS
WIFCONTINUED
WIFEXITED
WIFSIGNALED
WIFSTOPPED
WSTOPSIG
WTERMSIG
*/

extern (D) @safe pure
{
  bool WIFEXITED(int w)   { return (w & 0xFF) == 0; }
  bool WIFSIGNALED(int w) { return (w & 0x7F) > 0 && (w & 0x7F) < 0x7F; }
  bool WIFSTOPPED(int w)  { return (w & 0xFF) == 0x7F; }
  int  WEXITSTATUS(int w) { return (w >> 8) & 0xFF; }
  int  WTERMSIG(int w)    { return w & 0x7F; }

  alias WSTOPSIG = WEXITSTATUS;
}

/*
pid_t wait(int*);
pid_t waitpid(pid_t, int*, int);
*/

pid_t wait(int*);
pid_t waitpid(pid_t, int*, int);

//
// XOpen (XSI)
//
/*
WEXITED
WSTOPPED
WCONTINUED
WNOWAIT

enum idtype_t
{
    P_ALL,
    P_PID,
    P_PGID
}
*/

// 3dskit: not implemented in DKP

/*
int waitid(idtype_t, id_t, siginfo_t*, int);
*/

// 3dskit: not implemented
