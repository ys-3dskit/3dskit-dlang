/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.unistd;

import core.sys.horizon.config;
import core.stdc.stddef;
public import core.sys.horizon.inttypes;  // for intptr_t
public import core.sys.horizon.sys.types; // for ssize_t, uid_t, gid_t, off_t, pid_t, useconds_t

version (Horizon):
extern (C):
nothrow:
@nogc:

enum STDIN_FILENO  = 0;
enum STDOUT_FILENO = 1;
enum STDERR_FILENO = 2;

extern __gshared char*   optarg;
extern __gshared int     optind;
extern __gshared int     opterr;
extern __gshared int     optopt;

int     access(const scope char*, int);
uint    alarm(uint) @trusted;
int     chdir(const scope char*);
int     chown(const scope char*, uid_t, gid_t);
int     close(int) @trusted;
size_t  confstr(int, char*, size_t);
int     dup(int) @trusted;
int     dup2(int, int) @trusted;
int     execl(const scope char*, const scope char*, ...);
int     execle(const scope char*, const scope char*, ...);
int     execlp(const scope char*, const scope char*, ...);
int     execv(const scope char*, const scope char**);
int     execve(const scope char*, const scope char**, const scope char**);
int     execvp(const scope char*, const scope char**);
void    _exit(int) @trusted;
int     fchown(int, uid_t, gid_t) @trusted;
pid_t   fork() @trusted;
c_long  fpathconf(int, int) @trusted;
//int     ftruncate(int, off_t);
char*   getcwd(char*, size_t);
gid_t   getegid() @trusted;
uid_t   geteuid() @trusted;
gid_t   getgid() @trusted;
int     getgroups(int, gid_t *);
int     gethostname(char*, size_t);
char*   getlogin() @trusted;
int     getlogin_r(char*, size_t);
int     getopt(int, const scope char**, const scope char*);
pid_t   getpgrp() @trusted;
pid_t   getpid() @trusted;
pid_t   getppid() @trusted;
uid_t   getuid() @trusted;
int     isatty(int) @trusted;
int     link(const scope char*, const scope char*);
//off_t   lseek(int, off_t, int);
c_long  pathconf(const scope char*, int);
int     pause() @trusted;
int     pipe(ref int[2]) @trusted;
ssize_t read(int, void*, size_t);
ssize_t readlink(const scope char*, char*, size_t);
int     rmdir(const scope char*);
int     setegid(gid_t) @trusted;
int     seteuid(uid_t) @trusted;
int     setgid(gid_t) @trusted;
int     setgroups(size_t, const scope gid_t*) @trusted;
int     setpgid(pid_t, pid_t) @trusted;
pid_t   setsid() @trusted;
int     setuid(uid_t) @trusted;
uint    sleep(uint) @trusted;
int     symlink(const scope char*, const scope char*);
c_long  sysconf(int) @trusted;
pid_t   tcgetpgrp(int) @trusted;
int     tcsetpgrp(int, pid_t) @trusted;
char*   ttyname(int) @trusted;
int     ttyname_r(int, char*, size_t);
int     unlink(const scope char*);
ssize_t write(int, const scope void*, size_t);

// TODO

off_t lseek(int, off_t, int) @trusted;
int ftruncate(int, off_t) @trusted;

enum
{
  F_OK = 0,
  R_OK = 4,
  W_OK = 2,
  X_OK = 1,
}

enum
{
  F_ULOCK = 0,
  F_LOCK = 1,
  F_TLOCK = 2,
  F_TEST = 3,
}


enum
{
  _PC_LINK_MAX             = 0,
  _PC_MAX_CANON            = 1,
  _PC_MAX_INPUT            = 2,
  _PC_NAME_MAX             = 3,
  _PC_PATH_MAX             = 4,
  _PC_PIPE_BUF             = 5,
  _PC_CHOWN_RESTRICTED     = 6,
  _PC_NO_TRUNC             = 7,
  _PC_VDISABLE             = 8,
  _PC_ASYNC_IO             = 9,
  _PC_PRIO_IO              = 10,
  _PC_SYNC_IO              = 11,
  _PC_FILESIZEBITS         = 12,
  _PC_2_SYMLINKS           = 13,
  _PC_SYMLINK_MAX          = 14,
  _PC_ALLOC_SIZE_MIN       = 15,
  _PC_REC_INCR_XFER_SIZE   = 16,
  _PC_REC_MAX_XFER_SIZE    = 17,
  _PC_REC_MIN_XFER_SIZE    = 18,
  _PC_REC_XFER_ALIGN       = 19,
  _PC_TIMESTAMP_RESOLUTION = 20,
}

enum
{
  _SC_ARG_MAX                      = 0,
  _SC_CHILD_MAX                    = 1,
  _SC_CLK_TCK                      = 2,
  _SC_NGROUPS_MAX                  = 3,
  _SC_OPEN_MAX                     = 4,
  _SC_JOB_CONTROL                  = 5,
  _SC_SAVED_IDS                    = 6,
  _SC_VERSION                      = 7,
  _SC_PAGESIZE                     = 8,
  _SC_PAGE_SIZE                    = _SC_PAGESIZE,
  _SC_NPROCESSORS_CONF             = 9,
  _SC_NPROCESSORS_ONLN             = 10,
  _SC_PHYS_PAGES                   = 11,
  _SC_AVPHYS_PAGES                 = 12,
  _SC_MQ_OPEN_MAX                  = 13,
  _SC_MQ_PRIO_MAX                  = 14,
  _SC_RTSIG_MAX                    = 15,
  _SC_SEM_NSEMS_MAX                = 16,
  _SC_SEM_VALUE_MAX                = 17,
  _SC_SIGQUEUE_MAX                 = 18,
  _SC_TIMER_MAX                    = 19,
  _SC_TZNAME_MAX                   = 20,
  _SC_ASYNCHRONOUS_IO              = 21,
  _SC_FSYNC                        = 22,
  _SC_MAPPED_FILES                 = 23,
  _SC_MEMLOCK                      = 24,
  _SC_MEMLOCK_RANGE                = 25,
  _SC_MEMORY_PROTECTION            = 26,
  _SC_MESSAGE_PASSING              = 27,
  _SC_PRIORITIZED_IO               = 28,
  _SC_REALTIME_SIGNALS             = 29,
  _SC_SEMAPHORES                   = 30,
  _SC_SHARED_MEMORY_OBJECTS        = 31,
  _SC_SYNCHRONIZED_IO              = 32,
  _SC_TIMERS                       = 33,
  _SC_AIO_LISTIO_MAX               = 34,
  _SC_AIO_MAX                      = 35,
  _SC_AIO_PRIO_DELTA_MAX           = 36,
  _SC_DELAYTIMER_MAX               = 37,
  _SC_THREAD_KEYS_MAX              = 38,
  _SC_THREAD_STACK_MIN             = 39,
  _SC_THREAD_THREADS_MAX           = 40,
  _SC_TTY_NAME_MAX                 = 41,
  _SC_THREADS                      = 42,
  _SC_THREAD_ATTR_STACKADDR        = 43,
  _SC_THREAD_ATTR_STACKSIZE        = 44,
  _SC_THREAD_PRIORITY_SCHEDULING   = 45,
  _SC_THREAD_PRIO_INHERIT          = 46,
  _SC_THREAD_PRIO_PROTECT          = 47,
  _SC_THREAD_PRIO_CEILING          = _SC_THREAD_PRIO_PROTECT,
  _SC_THREAD_PROCESS_SHARED        = 48,
  _SC_THREAD_SAFE_FUNCTIONS        = 49,
  _SC_GETGR_R_SIZE_MAX             = 50,
  _SC_GETPW_R_SIZE_MAX             = 51,
  _SC_LOGIN_NAME_MAX               = 52,
  _SC_THREAD_DESTRUCTOR_ITERATIONS = 53,
  _SC_ADVISORY_INFO                = 54,
  _SC_ATEXIT_MAX                   = 55,
  _SC_BARRIERS                     = 56,
  _SC_BC_BASE_MAX                  = 57,
  _SC_BC_DIM_MAX                   = 58,
  _SC_BC_SCALE_MAX                 = 59,
  _SC_BC_STRING_MAX                = 60,
  _SC_CLOCK_SELECTION              = 61,
  _SC_COLL_WEIGHTS_MAX             = 62,
  _SC_CPUTIME                      = 63,
  _SC_EXPR_NEST_MAX                = 64,
  _SC_HOST_NAME_MAX                = 65,
  _SC_IOV_MAX                      = 66,
  _SC_IPV6                         = 67,
  _SC_LINE_MAX                     = 68,
  _SC_MONOTONIC_CLOCK              = 69,
  _SC_RAW_SOCKETS                  = 70,
  _SC_READER_WRITER_LOCKS          = 71,
  _SC_REGEXP                       = 72,
  _SC_RE_DUP_MAX                   = 73,
  _SC_SHELL                        = 74,
  _SC_SPAWN                        = 75,
  _SC_SPIN_LOCKS                   = 76,
  _SC_SPORADIC_SERVER              = 77,
  _SC_SS_REPL_MAX                  = 78,
  _SC_SYMLOOP_MAX                  = 79,
  _SC_THREAD_CPUTIME               = 80,
  _SC_THREAD_SPORADIC_SERVER       = 81,
  _SC_TIMEOUTS                     = 82,
  _SC_TRACE                        = 83,
  _SC_TRACE_EVENT_FILTER           = 84,
  _SC_TRACE_EVENT_NAME_MAX         = 85,
  _SC_TRACE_INHERIT                = 86,
  _SC_TRACE_LOG                    = 87,
  _SC_TRACE_NAME_MAX               = 88,
  _SC_TRACE_SYS_MAX                = 89,
  _SC_TRACE_USER_EVENT_MAX         = 90,
  _SC_TYPED_MEMORY_OBJECTS         = 91,
  _SC_V7_ILP32_OFF32               = 92,
  _SC_V6_ILP32_OFF32               = _SC_V7_ILP32_OFF32,
  _SC_XBS5_ILP32_OFF32             = _SC_V7_ILP32_OFF32,
  _SC_V7_ILP32_OFFBIG              = 93,
  _SC_V6_ILP32_OFFBIG              = _SC_V7_ILP32_OFFBIG,
  _SC_XBS5_ILP32_OFFBIG            = _SC_V7_ILP32_OFFBIG,
  _SC_V7_LP64_OFF64                = 94,
  _SC_V6_LP64_OFF64                = _SC_V7_LP64_OFF64,
  _SC_XBS5_LP64_OFF64              = _SC_V7_LP64_OFF64,
  _SC_V7_LPBIG_OFFBIG              = 95,
  _SC_V6_LPBIG_OFFBIG              = _SC_V7_LPBIG_OFFBIG,
  _SC_XBS5_LPBIG_OFFBIG            = _SC_V7_LPBIG_OFFBIG,
  _SC_XOPEN_CRYPT                  = 96,
  _SC_XOPEN_ENH_I18N               = 97,
  _SC_XOPEN_LEGACY                 = 98,
  _SC_XOPEN_REALTIME               = 99,
  _SC_STREAM_MAX                   = 100,
  _SC_PRIORITY_SCHEDULING          = 101,
  _SC_XOPEN_REALTIME_THREADS       = 102,
  _SC_XOPEN_SHM                    = 103,
  _SC_XOPEN_STREAMS                = 104,
  _SC_XOPEN_UNIX                   = 105,
  _SC_XOPEN_VERSION                = 106,
  _SC_2_CHAR_TERM                  = 107,
  _SC_2_C_BIND                     = 108,
  _SC_2_C_DEV                      = 109,
  _SC_2_FORT_DEV                   = 110,
  _SC_2_FORT_RUN                   = 111,
  _SC_2_LOCALEDEF                  = 112,
  _SC_2_PBS                        = 113,
  _SC_2_PBS_ACCOUNTING             = 114,
  _SC_2_PBS_CHECKPOINT             = 115,
  _SC_2_PBS_LOCATE                 = 116,
  _SC_2_PBS_MESSAGE                = 117,
  _SC_2_PBS_TRACK                  = 118,
  _SC_2_SW_DEV                     = 119,
  _SC_2_UPE                        = 120,
  _SC_2_VERSION                    = 121,
  _SC_THREAD_ROBUST_PRIO_INHERIT   = 122,
  _SC_THREAD_ROBUST_PRIO_PROTECT   = 123,
  _SC_XOPEN_UUCP                   = 124,
  _SC_LEVEL1_ICACHE_SIZE           = 125,
  _SC_LEVEL1_ICACHE_ASSOC          = 126,
  _SC_LEVEL1_ICACHE_LINESIZE       = 127,
  _SC_LEVEL1_DCACHE_SIZE           = 128,
  _SC_LEVEL1_DCACHE_ASSOC          = 129,
  _SC_LEVEL1_DCACHE_LINESIZE       = 130,
  _SC_LEVEL2_CACHE_SIZE            = 131,
  _SC_LEVEL2_CACHE_ASSOC           = 132,
  _SC_LEVEL2_CACHE_LINESIZE        = 133,
  _SC_LEVEL3_CACHE_SIZE            = 134,
  _SC_LEVEL3_CACHE_ASSOC           = 135,
  _SC_LEVEL3_CACHE_LINESIZE        = 136,
  _SC_LEVEL4_CACHE_SIZE            = 137,
  _SC_LEVEL4_CACHE_ASSOC           = 138,
  _SC_LEVEL4_CACHE_LINESIZE        = 139,
  _SC_POSIX_26_VERSION             = 140,
}

//
// File Synchronization (FSC)
//
/*
int fsync(int);
*/

int fsync(int) @trusted;

//
// Synchronized I/O (SIO)
//
/*
int fdatasync(int);
*/

int fdatasync(int) @trusted;

//
// XOpen (XSI)
//
/*
char*      crypt(const scope char*, const scope char*);
char*      ctermid(char*);
void       encrypt(ref char[64], int);
int        fchdir(int);
c_long     gethostid();
pid_t      getpgid(pid_t);
pid_t      getsid(pid_t);
char*      getwd(char*); // LEGACY
int        lchown(const scope char*, uid_t, gid_t);
int        lockf(int, int, off_t);
int        nice(int);
ssize_t    pread(int, void*, size_t, off_t);
ssize_t    pwrite(int, const scope void*, size_t, off_t);
pid_t      setpgrp();
int        setregid(gid_t, gid_t);
int        setreuid(uid_t, uid_t);
void       swab(const scope void*, void*, ssize_t);
void       sync();
int        truncate(const scope char*, off_t);
useconds_t ualarm(useconds_t, useconds_t);
int        usleep(useconds_t);
pid_t      vfork();
*/

char* crypt(const scope char*, const scope char*);
char* ctermid(char*);
void encrypt(ref char[64], int);
int fchdir(int);
c_long gethostid();
pid_t getpgid(pid_t);
pid_t getsid(pid_t);
char* getwd(char*); // LEGACY
int lchown(const scope char*, uid_t, gid_t);
int lockf(int, int, off_t);
int nice(int);
ssize_t pread(int, void*, size_t, off_t);
ssize_t pwrite(int, const scope void*, size_t, off_t);
pid_t setpgrp();
int setregid(gid_t, gid_t);
int setreuid(uid_t, uid_t);
void swab(const scope void*, void*, ssize_t);
void sync();
int truncate(const scope char*, off_t);
useconds_t ualarm(useconds_t, useconds_t);
int usleep(useconds_t);
pid_t vfork();

// Non-standard definition to access user process environment
extern __gshared const char** environ;
