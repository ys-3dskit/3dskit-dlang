/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Sean Kelly,
              Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 * Source:    $(DRUNTIMESRC core/sys/posix/_signal.d)
 */

module core.sys.horizon.signal;

import core.sys.horizon.config;
public import core.stdc.signal;
public import core.sys.horizon.sys.types; // for pid_t
public import core.sys.horizon.time; // for timespec

// pretty sure we need to re-export this later for ucontext_t and mcontext_t -- sink
public import core.sys.horizon.ucontext : ucontext_t, mcontext_t;

version (Horizon):
extern (C):
//nothrow:  // this causes http://issues.dlang.org/show_bug.cgi?id=12738 (which has been fixed)
//@system:

//
// Required
//
/*
SIG_DFL (defined in core.stdc.signal)
SIG_ERR (defined in core.stdc.signal)
SIG_IGN (defined in core.stdc.signal)

sig_atomic_t (defined in core.stdc.signal)

SIGEV_NONE
SIGEV_SIGNAL
SIGEV_THREAD

union sigval
{
    int   sival_int;
    void* sival_ptr;
}

SIGRTMIN
SIGRTMAX

SIGABRT (defined in core.stdc.signal)
SIGALRM
SIGBUS
SIGCHLD
SIGCONT
SIGFPE (defined in core.stdc.signal)
SIGHUP
SIGILL (defined in core.stdc.signal)
SIGINT (defined in core.stdc.signal)
SIGKILL
SIGPIPE
SIGQUIT
SIGSEGV (defined in core.stdc.signal)
SIGSTOP
SIGTERM (defined in core.stdc.signal)
SIGTSTP
SIGTTIN
SIGTTOU
SIGUSR1
SIGUSR2
SIGURG

struct sigaction_t
{
    sigfn_t     sa_handler;
    sigset_t    sa_mask;
    sigactfn_t  sa_sigaction;
}

sigfn_t signal(int sig, sigfn_t func); (defined in core.stdc.signal)
int raise(int sig);                    (defined in core.stdc.signal)
*/

private alias void function(int) sigfn_t;
private alias void function(int, siginfo_t*, void*) sigactfn_t;

// nothrow versions
nothrow @nogc
{
    private alias void function(int) sigfn_t2;
    private alias void function(int, siginfo_t*, void*) sigactfn_t2;
}

enum
{
  SIGEV_SIGNAL = 2,
  SIGEV_NONE = 1,
  SIGEV_THREAD = 3
}

union sigval
{
    int     sival_int;
    void*   sival_ptr;
}

enum SIGRTMIN = 27;
enum SIGRTMAX = 31;

enum
{ // dkp sys signal
  SIGALRM = 13,
  SIGBUS = 14,
  SIGCHLD = 20,
  SIGCONT = 19,
  SIGHUP = 1,
  SIGKILL = 9,
  SIGPIPE = 3,
  SIGQUIT = 9,
  SIGSTOP = 16,
  SIGTSTP = 8,
  SIGTTIN = 21,
  SIGTTOU = 22,
  SIGUSR1 = 30,
  SIGUSR2 = 31,
  SIGURG = 16,
}

struct sigaction_t
{
  int sa_flags;
  sigset_t sa_mask;
  union
  {
    sigfn_t sa_handler;
    sigactfn_t sa_sigaction;
  }
}

//
// C Extension (CX)
//
/*
SIG_HOLD

sigset_t
pid_t   (defined in core.sys.types)

SIGABRT (defined in core.stdc.signal)
SIGFPE  (defined in core.stdc.signal)
SIGILL  (defined in core.stdc.signal)
SIGINT  (defined in core.stdc.signal)
SIGSEGV (defined in core.stdc.signal)
SIGTERM (defined in core.stdc.signal)

SA_NOCLDSTOP (CX|XSI)
SIG_BLOCK
SIG_UNBLOCK
SIG_SETMASK

struct siginfo_t
{
    int     si_signo;
    int     si_code;

    version (XSI)
    {
        int     si_errno;
        pid_t   si_pid;
        uid_t   si_uid;
        void*   si_addr;
        int     si_status;
        c_long  si_band;
    }
    version (RTS)
    {
        sigval  si_value;
    }
}

SI_USER
SI_QUEUE
SI_TIMER
SI_ASYNCIO
SI_MESGQ
*/

nothrow @nogc
{

  // no SIG_HOLD

  // dkp sys _sigset
  alias sigset_t = c_ulong;

  // dkp sys signal
  enum
  {
    SA_NOCLDSTOP = 1,
    SIG_BLOCK = 1,
    SIG_UNBLOCK = 2,
    SIG_SETMASK = 0,
  }

  struct siginfo_t
  {
    int si_signo;
    int si_code;
    sigval si_value;
  }

  enum
  {
    SI_USER = 1,
    SI_QUEUE = 2,
    SI_TIMER = 3,
    SI_ASYNCIO = 4,
    SI_MESGQ = 5,
  }

  /*
  int kill(pid_t, int);
  int sigaction(int, const scope sigaction_t*, sigaction_t*);
  int sigaddset(sigset_t*, int);
  int sigdelset(sigset_t*, int);
  int sigemptyset(sigset_t*);
  int sigfillset(sigset_t*);
  int sigismember(const scope sigset_t*, int);
  int sigpending(sigset_t*);
  int sigprocmask(int, const scope sigset_t*, sigset_t*);
  int sigsuspend(const scope sigset_t*);
  int sigwait(const scope sigset_t*, int*);
  */

  int kill(pid_t, int);
  int sigaction(int, const scope sigaction_t*, sigaction_t*);
  int sigaddset(sigset_t*, int);
  int sigdelset(sigset_t*, int);
  int sigemptyset(sigset_t*);
  int sigfillset(sigset_t*);
  int sigismember(const scope sigset_t*, int);
  int sigpending(sigset_t*);
  int sigprocmask(int, const scope sigset_t*, sigset_t*);
  int sigsuspend(const scope sigset_t*);
  int sigwait(const scope sigset_t*, int*);
}

enum
{
  SIGPOLL = SIGIO,
  SIGPROF = 27,
  SIGSYS = 12,
  SIGTRAP = 5,
  SIGVTALRM = 26,
  SIGXCPU = 24,
  SIGXFSZ = 25,

  SA_ONSTACK = 0x4,
  //SA_RESETHAND = ,
  //SA_RESTART = ,
  SA_SIGINFO = 0x2,
  SA_NOCLDWAIT = 0x1,
  //SA_NODEFER = ,

  //ILL_ILLOPC = ,
  //ILL_ILLOPN = ,
  //ILL_ILLADR = ,
  //ILL_ILLTRP = ,
  //ILL_PRVOPC = ,
  //ILL_PRVREG = ,
  //ILL_COPROC = ,
  //ILL_BADSTK = ,

  //FPE_INTDIV = ,
  //FPE_INTOVF = ,
  //FPE_FLTDIV = ,
  //FPE_FLTOVF = ,
  //FPE_FLTUND = ,
  //FPE_FLTRES = ,
  //FPE_FLTINV = ,
  //FPE_FLTSUB = ,

  //SEGV_MAPERR = ,
  //SEGV_ACCERR = ,

  //BUS_ADRALN = ,
  //BUS_ADRERR = ,
  //BUS_OBJERR = ,

  //TRAP_BRKPT = ,
  //TRAP_TRACE = ,

  //CLD_EXITED = ,
  //CLD_KILLED = ,
  //CLD_DUMPED = ,
  //CLD_TRAPPED = ,
  //CLD_STOPPED = ,
  //CLD_CONTINUED = ,

  //POLL_IN = ,
  //POLL_OUT = ,
  //POLL_MSG = ,
  //POLL_ERR = ,
  //POLL_PRI = ,
  //POLL_HUP = ,
}

// TODO: finish

/*
SS_ONSTACK
SS_DISABLE
MINSIGSTKSZ
SIGSTKSZ

ucontext_t // from ucontext
mcontext_t // from ucontext

struct stack_t
{
    void*   ss_sp;
    size_t  ss_size;
    int     ss_flags;
}

struct sigstack
{
    int   ss_onstack;
    void* ss_sp;
}

sigfn_t bsd_signal(int sig, sigfn_t func);
sigfn_t sigset(int sig, sigfn_t func);

int killpg(pid_t, int);
int sigaltstack(const scope stack_t*, stack_t*);
int sighold(int);
int sigignore(int);
int siginterrupt(int, int);
int sigpause(int);
int sigrelse(int);
*/

enum
{
  SS_ONSTACK = 0x1,
  SS_DISABLE = 0x2,

  MINSIGSTKSZ = 2048,
  SIGSTKSZ = 8192
}

struct stack_t
{
  void* ss_sp;
  int ss_flags;
  size_t ss_size;
}

//sigfn_t bsd_signal()
//sigfn_t sigset()

int killpg(pid_t, int);
int sigaltstack(const scope stack_t*, stack_t*);
//int sighold(int);
//int sigignore(int);
//int siginterrupt(int, int);
int sigpause(int);
//int sigrelse(int);

//
// Realtime Signals (RTS)
//
/*
struct sigevent
{
    int             sigev_notify;
    int             sigev_signo;
    sigval          sigev_value;
    void(*)(sigval) sigev_notify_function;
    pthread_attr_t* sigev_notify_attributes;
}
*/

nothrow:
@nogc:

struct sigevent
{
  int sigev_notify;
  int sigev_signo;
  sigval sigev_value;

  // ifdef _POSIX_THREADS (?)
  void* function(sigval) sigev_notify_function;
  pthread_attr_t* sigev_notify_attributes;
}

/*
int sigqueue(pid_t, int, const sigval);
int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
int sigwaitinfo(const scope sigset_t*, siginfo_t*);
*/

nothrow:
@nogc:

int sigqueue(pid_t, int, const sigval);
int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
int sigwaitinfo(const scope sigset_t*, siginfo_t*);

//
// Threads (THR)
//
/*
int pthread_kill(pthread_t, int);
int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
*/

int pthread_kill(pthread_t, int);
int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
