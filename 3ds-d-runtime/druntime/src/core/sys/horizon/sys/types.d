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
module core.sys.horizon.sys.types;

import core.sys.horizon.config;
import core.stdc.stdint;
public import core.stdc.stddef;

version (Horizon):
extern (C):

//
// bits/typesizes.h -- underlying types for *_t.
//
/*
__syscall_slong_t
__syscall_ulong_t
*/

// [3dskit] not defined by devkitarm

//
// Required
//
/*
blkcnt_t
blksize_t
dev_t
gid_t
ino_t
mode_t
nlink_t
off_t
pid_t
size_t
ssize_t
time_t
uid_t
*/

alias blkcnt_t = c_long;
alias blksize_t = c_long;
alias dev_t = short;
alias gid_t = ushort;
alias ino_t = ushort;
alias mode_t = uint;
alias nlink_t = ushort;
alias off_t = c_long;
alias pid_t = int;
alias ssize_t = ptrdiff_t;
alias time_t = c_long;
alias uid_t = ushort;

//
// XOpen (XSI)
//
/*
clock_t
fsblkcnt_t
fsfilcnt_t
id_t
key_t
suseconds_t
useconds_t
*/

alias clock_t = c_ulong;
alias fsblkcnt_t = ulong;
alias fsfilcnt_t = uint;
alias id_t = uint;
alias key_t = c_long;
alias suseconds_t = c_long;
alias useconds_t = c_ulong;

//
// Thread (THR)
//
/*
pthread_attr_t
pthread_cond_t
pthread_condattr_t
pthread_key_t
pthread_mutex_t
pthread_mutexattr_t
pthread_once_t
pthread_rwlock_t
pthread_rwlockattr_t
pthread_t
*/

// [3dskit]: no posix threads lol

//
// Barrier (BAR)
//
/*
pthread_barrier_t
pthread_barrierattr_t
*/

// ditto

//
// Spin (SPN)
//
/*
pthread_spinlock_t
*/

// ditto.

//
// Timer (TMR)
//
/*
clockid_t
timer_t
*/

alias clockid_t = c_ulong;
alias timer_t = c_ulong;

//
// Trace (TRC)
//
/*
trace_attr_t
trace_event_id_t
trace_event_set_t
trace_id_t
*/

// not defined.
