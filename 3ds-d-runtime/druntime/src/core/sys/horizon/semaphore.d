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
module core.sys.horizon.semaphore;

import core.sys.horizon.config;
import core.sys.horizon.time;

version (Horizon):
extern (C):
nothrow:
@nogc:

//
// Required
//
/*
sem_t
SEM_FAILED

int sem_close(sem_t*);
int sem_destroy(sem_t*);
int sem_getvalue(sem_t*, int*);
int sem_init(sem_t*, int, uint);
sem_t* sem_open(const scope char*, int, ...);
int sem_post(sem_t*);
int sem_trywait(sem_t*);
int sem_unlink(const scope char*);
int sem_wait(sem_t*);
*/

struct sem_t
{
  uint lock;
  uint cond;
  int value;
}

enum SEM_FAILED = cast(sem_t*) 0;

int sem_close(sem_t*);
int sem_destroy(sem_t*);
int sem_getvalue(sem_t*, int*);
int sem_init(sem_t*, int, uint);
sem_t* sem_open(const scope char*, int, ...);
int sem_post(sem_t*);
int sem_trywait(sem_t*);
int sem_unlink(const scope char*);
int sem_wait(sem_t*);

//
// Timeouts (TMO)
//
/*
int sem_timedwait(sem_t*, const scope timespec*);
*/

int sem_timedwait(sem_t*, const scope timespec*);
