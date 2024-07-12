/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly,
              Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.time;

import core.sys.horizon.config;
public import core.stdc.time;
public import core.sys.horizon.sys.types;
public import core.sys.horizon.signal; // for sigevent

version (Horizon):
extern (C):
nothrow:
@nogc:

//
// Required (defined in core.stdc.time)
//
/*
char* asctime(const scope tm*);
clock_t clock();
char* ctime(const scope time_t*);
double difftime(time_t, time_t);
tm* gmtime(const scope time_t*);
tm* localtime(const scope time_t*);
time_t mktime(tm*);
size_t strftime(char*, size_t, const scope char*, const scope tm*);
time_t time(time_t*);
*/

// no timegm()

//
// C Extension (CX)
// (defined in core.stdc.time)
//
/*
char* tzname[];
void tzset();
*/

//
// Process CPU-Time Clocks (CPT)
//
/*
int clock_getcpuclockid(pid_t, clockid_t*);
*/

//
// Clock Selection (CS)
//
/*
int clock_nanosleep(clockid_t, int, const scope timespec*, timespec*);
*/

//
// Monotonic Clock (MON)
//
/*
CLOCK_MONOTONIC
*/

enum CLOCK_MONOTONIC = 4;

//
// Timer (TMR)
//
/*
CLOCK_PROCESS_CPUTIME_ID (TMR|CPT)
CLOCK_THREAD_CPUTIME_ID (TMR|TCT)

struct timespec
{
    time_t  tv_sec;
    int     tv_nsec;
}

struct itimerspec
{
    timespec it_interval;
    timespec it_value;
}

CLOCK_REALTIME
TIMER_ABSTIME

clockid_t
timer_t

int clock_getres(clockid_t, timespec*);
int clock_gettime(clockid_t, timespec*);
int clock_settime(clockid_t, const scope timespec*);
int nanosleep(const scope timespec*, timespec*);
int timer_create(clockid_t, sigevent*, timer_t*);
int timer_delete(timer_t);
int timer_gettime(timer_t, itimerspec*);
int timer_getoverrun(timer_t);
int timer_settime(timer_t, int, const scope itimerspec*, itimerspec*);
*/

struct timespec
{
  time_t tv_sec;
  c_long tv_nsec;
}

enum CLOCK_PROCESS_CPUTIME_ID = 2;
enum CLOCK_THREAD_CPUTIME_ID = 3;

struct itimerspec
{
  timespec it_interval;
  timespec it_value;
}

enum CLOCK_REALTIME = 1;
enum TIMER_ABSTIME = 4;

alias clockid_t = c_ulong;
alias timer_t = c_ulong;

int clock_getres(clockid_t, timespec*);
int clock_gettime(clockid_t, timespec*);
int clock_settime(clockid_t, const scope timespec*);

int nanosleep(const scope timespec*, timespec*);

int timer_create(clockid_t, sigevent*, timer_t*);
int timer_delete(timer_t);
int timer_gettime(timer_t, itimerspec*);
int timer_getoverrun(timer_t);
int timer_settime(timer_t, int, const scope itimerspec*, itimerspec*);

//
// Thread-Safe Functions (TSF)
//
/*
char* asctime_r(const scope tm*, char*);
char* ctime_r(const scope time_t*, char*);
tm*   gmtime_r(const scope time_t*, tm*);
tm*   localtime_r(const scope time_t*, tm*);
*/

char* asctime_r(const scope tm*, char*);
char* ctime_r(const scope time_t*, char*);
tm* gmtime_r(const scope time_t*, tm*);
tm* localtime_r(const scope time_t*, tm*);

//
// XOpen (XSI)
//
/*
getdate_err

int daylight;
int timezone;

tm* getdate(const scope char*);
char* strptime(const scope char*, const scope char*, tm*);
*/

pragma(mangle, "_timezone") extern __gshared c_ulong timezone;
pragma(mangle, "_daylight") extern __gshared int daylight;

tm* getdate(const scope char*);
char* strptime(const scope char*, const scope char*, tm*);
