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
module core.sys.horizon.sys.time;

import core.sys.horizon.config;
public import core.sys.horizon.sys.types;  // for time_t, suseconds_t
public import core.sys.horizon.sys.select; // for fd_set, FD_CLR() FD_ISSET() FD_SET() FD_ZERO() FD_SETSIZE, select()


version (Horizon):
extern (C) nothrow @nogc:

//
// XOpen (XSI)
//
/*
struct timeval
{
    time_t      tv_sec;
    suseconds_t tv_usec;
}

struct itimerval
{
    timeval it_interval;
    timeval it_value;
}

ITIMER_REAL
ITIMER_VIRTUAL
ITIMER_PROF

int getitimer(int, itimerval*);
int gettimeofday(timeval*, void*);
int select(int, fd_set*, fd_set*, fd_set*, timeval*); (defined in core.sys.posix.sys.signal)
int setitimer(int, const scope itimerval*, itimerval*);
int utimes(const scope char*, ref const(timeval)[2]); // LEGACY
*/

struct timeval {
  time_t tv_sec; // seconds
  suseconds_t tv_usec; // microseconds
}

struct itimerval
{
  timeval it_interval;
  timeval it_value;
}

enum ITIMER_REAL = 0;
enum ITIMER_VIRTUAL = 1;
enum ITIMER_PROF = 2;

int getitimer(int, itimerval*);
int gettimeofday(timeval*, void*);
int setitimer(int, const scope itimerval*, itimerval*);
int utimes(const scope char*, ref const(timeval)[2]); // LEGACY
