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

// TODO: finish

//
// XOpen (XSI)
//
/*
SIGPOLL
SIGPROF
SIGSYS
SIGTRAP
SIGVTALRM
SIGXCPU
SIGXFSZ

SA_ONSTACK
SA_RESETHAND
SA_RESTART
SA_SIGINFO
SA_NOCLDWAIT
SA_NODEFER

ILL_ILLOPC
ILL_ILLOPN
ILL_ILLADR
ILL_ILLTRP
ILL_PRVOPC
ILL_PRVREG
ILL_COPROC
ILL_BADSTK

FPE_INTDIV
FPE_INTOVF
FPE_FLTDIV
FPE_FLTOVF
FPE_FLTUND
FPE_FLTRES
FPE_FLTINV
FPE_FLTSUB

SEGV_MAPERR
SEGV_ACCERR

BUS_ADRALN
BUS_ADRERR
BUS_OBJERR

TRAP_BRKPT
TRAP_TRACE

CLD_EXITED
CLD_KILLED
CLD_DUMPED
CLD_TRAPPED
CLD_STOPPED
CLD_CONTINUED

POLL_IN
POLL_OUT
POLL_MSG
POLL_ERR
POLL_PRI
POLL_HUP
*/

version (linux)
{
    version (X86_Any)
    {
        enum SIGPOLL        = 29;
        enum SIGPROF        = 27;
        enum SIGSYS         = 31;
        enum SIGTRAP        = 5;
        enum SIGVTALRM      = 26;
        enum SIGXCPU        = 24;
        enum SIGXFSZ        = 25;
    }
    else version (HPPA_Any)
    {
        enum SIGPOLL    = 22;
        enum SIGPROF    = 21;
        enum SIGSYS     = 31;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 20;
        enum SIGXCPU    = 12;
        enum SIGXFSZ    = 30;
    }
    else version (MIPS_Any)
    {
        enum SIGPOLL    = 22;
        enum SIGPROF    = 29;
        enum SIGSYS     = 12;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 28;
        enum SIGXCPU    = 30;
        enum SIGXFSZ    = 31;
    }
    else version (PPC_Any)
    {
        enum SIGPOLL    = 29;
        enum SIGPROF    = 27;
        enum SIGSYS     = 31;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 26;
        enum SIGXCPU    = 24;
        enum SIGXFSZ    = 25;
    }
    else version (ARM_Any)
    {
        enum SIGPOLL    = 29;
        enum SIGPROF    = 27;
        enum SIGSYS     = 31;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 26;
        enum SIGXCPU    = 24;
        enum SIGXFSZ    = 25;
    }
    else version (RISCV_Any)
    {
        enum SIGPOLL    = 29;
        enum SIGPROF    = 27;
        enum SIGSYS     = 31;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 26;
        enum SIGXCPU    = 24;
        enum SIGXFSZ    = 25;
    }
    else version (SPARC_Any)
    {
        enum SIGPOLL    = 23;
        enum SIGPROF    = 27;
        enum SIGSYS     = 12;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 26;
        enum SIGXCPU    = 24;
        enum SIGXFSZ    = 25;
    }
    else version (IBMZ_Any)
    {
        enum SIGPOLL    = 29;
        enum SIGPROF    = 27;
        enum SIGSYS     = 31;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 26;
        enum SIGXCPU    = 24;
        enum SIGXFSZ    = 25;
    }
    else version (LoongArch64)
    {
        enum SIGPOLL    = 29;
        enum SIGPROF    = 27;
        enum SIGSYS     = 31;
        enum SIGTRAP    = 5;
        enum SIGVTALRM  = 26;
        enum SIGXCPU    = 24;
        enum SIGXFSZ    = 25;
    }
    else
        static assert(0, "unimplemented");

    version (MIPS_Any)
    {
        enum SA_ONSTACK   = 0x08000000;
        enum SA_RESETHAND = 0x80000000;
        enum SA_RESTART   = 0x10000000;
        enum SA_SIGINFO   = 8;
        enum SA_NOCLDWAIT = 0x10000;
        enum SA_NODEFER   = 0x40000000;
    }
    else
    {
        enum SA_ONSTACK   = 0x08000000;
        enum SA_RESETHAND = 0x80000000;
        enum SA_RESTART   = 0x10000000;
        enum SA_SIGINFO   = 4;
        enum SA_NOCLDWAIT = 2;
        enum SA_NODEFER   = 0x40000000;
    }

    enum SA_NOMASK      = SA_NODEFER;
    enum SA_ONESHOT     = SA_RESETHAND;
    enum SA_STACK       = SA_ONSTACK;

    enum
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN,
        ILL_ILLADR,
        ILL_ILLTRP,
        ILL_PRVOPC,
        ILL_PRVREG,
        ILL_COPROC,
        ILL_BADSTK
    }

    enum
    {
        FPE_INTDIV = 1,
        FPE_INTOVF,
        FPE_FLTDIV,
        FPE_FLTOVF,
        FPE_FLTUND,
        FPE_FLTRES,
        FPE_FLTINV,
        FPE_FLTSUB
    }

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP
    }
}
else version (Darwin)
{
    enum SIGPOLL        = 7;
    enum SIGPROF        = 27;
    enum SIGSYS         = 12;
    enum SIGTRAP        = 5;
    enum SIGVTALRM      = 26;
    enum SIGXCPU        = 24;
    enum SIGXFSZ        = 25;

    enum SA_ONSTACK     = 0x0001;
    enum SA_RESETHAND   = 0x0004;
    enum SA_RESTART     = 0x0002;
    enum SA_SIGINFO     = 0x0040;
    enum SA_NOCLDWAIT   = 0x0020;
    enum SA_NODEFER     = 0x0010;

    enum ILL_ILLOPC = 1;
    enum ILL_ILLOPN = 4;
    enum ILL_ILLADR = 5;
    enum ILL_ILLTRP = 2;
    enum ILL_PRVOPC = 3;
    enum ILL_PRVREG = 6;
    enum ILL_COPROC = 7;
    enum ILL_BADSTK = 8;

    enum FPE_INTDIV = 7;
    enum FPE_INTOVF = 8;
    enum FPE_FLTDIV = 1;
    enum FPE_FLTOVF = 2;
    enum FPE_FLTUND = 3;
    enum FPE_FLTRES = 4;
    enum FPE_FLTINV = 5;
    enum FPE_FLTSUB = 6;

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP
    }
}
else version (FreeBSD)
{
    // No SIGPOLL on *BSD
    enum SIGPROF        = 27;
    enum SIGSYS         = 12;
    enum SIGTRAP        = 5;
    enum SIGVTALRM      = 26;
    enum SIGXCPU        = 24;
    enum SIGXFSZ        = 25;

    enum
    {
        SA_ONSTACK      = 0x0001,
        SA_RESTART      = 0x0002,
        SA_RESETHAND    = 0x0004,
        SA_NODEFER      = 0x0010,
        SA_NOCLDWAIT    = 0x0020,
        SA_SIGINFO      = 0x0040,
    }

    enum
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN,
        ILL_ILLADR,
        ILL_ILLTRP,
        ILL_PRVOPC,
        ILL_PRVREG,
        ILL_COPROC,
        ILL_BADSTK,
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR,
    }

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR,
    }

    enum
    {
        FPE_INTOVF = 1,
        FPE_INTDIV,
        FPE_FLTDIV,
        FPE_FLTOVF,
        FPE_FLTUND,
        FPE_FLTRES,
        FPE_FLTINV,
        FPE_FLTSUB,
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE,
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED,
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP,
    }
}
else version (NetBSD)
{
    // No SIGPOLL on *BSD
    enum SIGPROF        = 27;
    enum SIGSYS         = 12;
    enum SIGTRAP        = 5;
    enum SIGVTALRM      = 26;
    enum SIGXCPU        = 24;
    enum SIGXFSZ        = 25;

    enum
    {
        SA_ONSTACK      = 0x0001,
        SA_RESTART      = 0x0002,
        SA_RESETHAND    = 0x0004,
        SA_NODEFER      = 0x0010,
        SA_NOCLDWAIT    = 0x0020,
        SA_SIGINFO      = 0x0040,
    }

    enum
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN,
        ILL_ILLADR,
        ILL_ILLTRP,
        ILL_PRVOPC,
        ILL_PRVREG,
        ILL_COPROC,
        ILL_BADSTK,
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR,
    }

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR,
    }

    enum
    {
        FPE_INTOVF = 1,
        FPE_INTDIV,
        FPE_FLTDIV,
        FPE_FLTOVF,
        FPE_FLTUND,
        FPE_FLTRES,
        FPE_FLTINV,
        FPE_FLTSUB,
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE,
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED,
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP,
    }
}
else version (OpenBSD)
{
    // No SIGPOLL on *BSD
    enum SIGPROF        = 27;
    enum SIGSYS         = 12;
    enum SIGTRAP        = 5;
    enum SIGVTALRM      = 26;
    enum SIGXCPU        = 24;
    enum SIGXFSZ        = 25;

    enum
    {
        SA_ONSTACK      = 0x0001,
        SA_RESTART      = 0x0002,
        SA_RESETHAND    = 0x0004,
        SA_NODEFER      = 0x0010,
        SA_NOCLDWAIT    = 0x0020,
        SA_SIGINFO      = 0x0040,
    }

    enum
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN,
        ILL_ILLADR,
        ILL_ILLTRP,
        ILL_PRVOPC,
        ILL_PRVREG,
        ILL_COPROC,
        ILL_BADSTK,
        NSIGILL = ILL_BADSTK,
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR,
        NSIGBUS = BUS_OBJERR,
    }

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR,
        NSIGSEGV = SEGV_ACCERR,
    }

    enum
    {
        FPE_INTDIV = 1,
        FPE_INTOVF,
        FPE_FLTDIV,
        FPE_FLTOVF,
        FPE_FLTUND,
        FPE_FLTRES,
        FPE_FLTINV,
        FPE_FLTSUB,
        NSIGFPE = FPE_FLTSUB,
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE,
        NSIGTRAP = TRAP_TRACE,
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED,
        NSIGCLD = CLD_CONTINUED,
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP,
        NSIGPOLL = POLL_HUP,
    }
}
else version (DragonFlyBSD)
{
    // No SIGPOLL on *BSD
    enum SIGPROF        = 27;
    enum SIGSYS         = 12;
    enum SIGTRAP        = 5;
    enum SIGVTALRM      = 26;
    enum SIGXCPU        = 24;
    enum SIGXFSZ        = 25;

    enum
    {
        SA_ONSTACK      = 0x0001,
        SA_RESTART      = 0x0002,
        SA_RESETHAND    = 0x0004,
        SA_NODEFER      = 0x0010,
        SA_NOCLDWAIT    = 0x0020,
        SA_SIGINFO      = 0x0040,
    }

    enum
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN,
        ILL_ILLADR,
        ILL_ILLTRP,
        ILL_PRVOPC,
        ILL_PRVREG,
        ILL_COPROC,
        ILL_BADSTK,
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR,
    }

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR,
    }

    enum
    {
        FPE_INTOVF = 1,
        FPE_INTDIV,
        FPE_FLTDIV,
        FPE_FLTOVF,
        FPE_FLTUND,
        FPE_FLTRES,
        FPE_FLTINV,
        FPE_FLTSUB,
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE,
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED,
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP,
    }
}
else version (Solaris)
{
    enum SIGPOLL = 22;
    enum SIGIO = SIGPOLL;
    enum SIGPROF = 29;
    enum SIGSYS = 12;
    enum SIGTRAP = 5;
    enum SIGVTALRM = 28;
    enum SIGXCPU = 30;
    enum SIGXFSZ = 31;

    enum
    {
        SA_ONSTACK = 0x00001,
        SA_RESTART = 0x00004,
        SA_RESETHAND = 0x00002,
        SA_NODEFER = 0x00010,
        SA_NOCLDWAIT = 0x10000,
        SA_SIGINFO = 0x00008,
    }

    enum
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN,
        ILL_ILLADR,
        ILL_ILLTRP,
        ILL_PRVOPC,
        ILL_PRVREG,
        ILL_COPROC,
        ILL_BADSTK,
    }

    enum
    {
        BUS_ADRALN = 1,
        BUS_ADRERR,
        BUS_OBJERR,
    }

    enum
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR,
    }

    enum
    {
        FPE_INTDIV = 1,
        FPE_INTOVF,
        FPE_FLTDIV,
        FPE_FLTOVF,
        FPE_FLTUND,
        FPE_FLTRES,
        FPE_FLTINV,
        FPE_FLTSUB,
        FPE_FLTDEN,
    }

    enum
    {
        TRAP_BRKPT = 1,
        TRAP_TRACE,
        TRAP_RWATCH,
        TRAP_WWATCH,
        TRAP_XWATCH,
        TRAP_DTRACE,
    }

    enum
    {
        CLD_EXITED = 1,
        CLD_KILLED,
        CLD_DUMPED,
        CLD_TRAPPED,
        CLD_STOPPED,
        CLD_CONTINUED,
    }

    enum
    {
        POLL_IN = 1,
        POLL_OUT,
        POLL_MSG,
        POLL_ERR,
        POLL_PRI,
        POLL_HUP,
    }
}
else
{
    static assert(false, "Unsupported platform");
}

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

version (CRuntime_Glibc)
{
    enum SS_ONSTACK     = 1;
    enum SS_DISABLE     = 2;
    enum MINSIGSTKSZ    = 2048;
    enum SIGSTKSZ       = 8192;

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    version (MIPS_Any)
    {
        struct stack_t
        {
            void*   ss_sp;
            size_t  ss_size;
            int     ss_flags;
        }
    }
    else
    {
        struct stack_t
        {
            void*   ss_sp;
            int     ss_flags;
            size_t  ss_size;
        }
    }

    struct sigstack
    {
        void*   ss_sp;
        int     ss_onstack;
    }

    sigfn_t bsd_signal(int sig, sigfn_t func);
    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    sigfn_t2 bsd_signal(int sig, sigfn_t2 func);
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (Darwin)
{
    enum SS_ONSTACK     = 0x0001;
    enum SS_DISABLE     = 0x0004;
    enum MINSIGSTKSZ    = 32768;
    enum SIGSTKSZ       = 131072;

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    struct stack_t
    {
        void*   ss_sp;
        size_t  ss_size;
        int     ss_flags;
    }

    struct sigstack
    {
        void*   ss_sp;
        int     ss_onstack;
    }

    sigfn_t bsd_signal(int sig, sigfn_t func);
    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    sigfn_t2 bsd_signal(int sig, sigfn_t2 func);
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (FreeBSD)
{
    enum
    {
        SS_ONSTACK = 0x0001,
        SS_DISABLE = 0x0004,
    }

    enum MINSIGSTKSZ = 512 * 4;
    enum SIGSTKSZ    = (MINSIGSTKSZ + 32768);

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    struct stack_t
    {
        void*   ss_sp;
        size_t  ss_size;
        int     ss_flags;
    }

    struct sigstack
    {
        void*   ss_sp;
        int     ss_onstack;
    }

    //sigfn_t bsd_signal(int sig, sigfn_t func);
    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    //sigfn_t2 bsd_signal(int sig, sigfn_t2 func);
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (NetBSD)
{
    enum
    {
        SS_ONSTACK = 0x0001,
        SS_DISABLE = 0x0004,
    }

    enum MINSIGSTKSZ = 8192;
    enum SIGSTKSZ    = (MINSIGSTKSZ + 32768);

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    struct stack_t
    {
        void*   ss_sp;
        size_t  ss_size;
        int     ss_flags;
    }

    struct sigstack
    {
        void*   ss_sp;
        int     ss_onstack;
    }

    //sigfn_t bsd_signal(int sig, sigfn_t func);
    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    //sigfn_t2 bsd_signal(int sig, sigfn_t2 func);
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (OpenBSD)
{
    enum
    {
        SS_ONSTACK = 0x0001,
        SS_DISABLE = 0x0004,
    }

    enum MINSIGSTKSZ = 8192;
    enum SIGSTKSZ    = (MINSIGSTKSZ + 32768);

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    struct stack_t
    {
        void*   ss_sp;
        size_t  ss_size;
        int     ss_flags;
    }

  nothrow:
  @nogc:
    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int siginterrupt(int, int);
    int sigpause(int);
}
else version (DragonFlyBSD)
{
    enum
    {
        SS_ONSTACK = 0x0001,
        SS_DISABLE = 0x0004,
    }

    enum MINSIGSTKSZ = 8192;
    enum SIGSTKSZ    = (MINSIGSTKSZ + 32768);

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    struct stack_t
    {
        void*   ss_sp;
        size_t  ss_size;
        int     ss_flags;
    }

    struct sigstack
    {
        void*   ss_sp;
        int     ss_onstack;
    }

    //sigfn_t bsd_signal(int sig, sigfn_t func);
    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    //sigfn_t2 bsd_signal(int sig, sigfn_t2 func);
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (Solaris)
{
    enum
    {
        SS_ONSTACK = 0x0001,
        SS_DISABLE = 0x0002,
    }

    enum MINSIGSTKSZ = 2048;
    enum SIGSTKSZ = 8192;

    struct stack_t
    {
        void* ss_sp;
        size_t ss_size;
        int ss_flags;
    }

    struct sigstack
    {
        void* ss_sp;
        int ss_onstack;
    }

    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (CRuntime_Bionic)
{
    enum SS_ONSTACK     = 1;
    enum SS_DISABLE     = 2;
    enum MINSIGSTKSZ    = 2048;
    enum SIGSTKSZ       = 8192;

    struct stack_t
    {
        void*   ss_sp;
        int     ss_flags;
        size_t  ss_size;
    }

    sigfn_t bsd_signal(int, sigfn_t);

  nothrow:
  @nogc:
    sigfn_t2 bsd_signal(int, sigfn_t2);

    int killpg(int, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int siginterrupt(int, int);
}
else version (CRuntime_Musl)
{
    enum SS_ONSTACK = 1;
    enum SS_DISABLE = 2;

    version (ARM)
    {
        enum MINSIGSTKSZ = 2048;
        enum SIGSTKSZ    = 8192;
    }
    else version (AArch64)
    {
        enum MINSIGSTKSZ = 6144;
        enum SIGSTKSZ    = 12288;
    }
    else version (IBMZ_Any)
    {
        enum MINSIGSTKSZ = 4096;
        enum SIGSTKSZ    = 10240;
    }
    else version (MIPS_Any)
    {
        enum MINSIGSTKSZ = 2048;
        enum SIGSTKSZ    = 8192;
    }
    else version (PPC_Any)
    {
        enum MINSIGSTKSZ = 4096;
        enum SIGSTKSZ    = 10240;
    }
    else version (X86_Any)
    {
        enum MINSIGSTKSZ = 2048;
        enum SIGSTKSZ    = 8192;
    }
    else
        static assert(0, "unimplemented");

    //ucontext_t (defined in core.sys.posix.ucontext)
    //mcontext_t (defined in core.sys.posix.ucontext)

    version (MIPS_Any)
    {
        struct stack_t
        {
            void*  ss_sp;
            size_t ss_size;
            int    ss_flags;
        }
    }
    else
    {
        struct stack_t
        {
            void*  ss_sp;
            int    ss_flags;
            size_t ss_size;
        }
    }

    sigfn_t bsd_signal(int sig, sigfn_t func);
    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    sigfn_t2 bsd_signal(int sig, sigfn_t2 func);
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else version (CRuntime_UClibc)
{
    enum SS_ONSTACK     = 1;
    enum SS_DISABLE     = 2;
    enum MINSIGSTKSZ    = 2048;
    enum SIGSTKSZ       = 8192;

    version (MIPS_Any)
    {
        struct stack_t
        {
            void *ss_sp;
            size_t ss_size;
            int ss_flags;
        }
    }
    else
    {
        struct stack_t
        {
            void*   ss_sp;
            int     ss_flags;
            size_t  ss_size;
        }
     }

    struct sigstack
    {
        void*   ss_sp;
        int     ss_onstack;
    }

    sigfn_t sigset(int sig, sigfn_t func);

  nothrow:
  @nogc:
    sigfn_t2 sigset(int sig, sigfn_t2 func);

    int killpg(pid_t, int);
    int sigaltstack(const scope stack_t*, stack_t*);
    int sighold(int);
    int sigignore(int);
    int siginterrupt(int, int);
    int sigpause(int);
    int sigrelse(int);
}
else
{
    static assert(false, "Unsupported platform");
}

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

version (linux)
{
    private enum __SIGEV_MAX_SIZE = 64;

    static if ( __WORDSIZE == 64 )
    {
        private enum __SIGEV_PAD_SIZE = ((__SIGEV_MAX_SIZE / int.sizeof) - 4);
    }
    else
    {
        private enum __SIGEV_PAD_SIZE = ((__SIGEV_MAX_SIZE / int.sizeof) - 3);
    }

    struct sigevent
    {
        sigval      sigev_value;
        int         sigev_signo;
        int         sigev_notify;

        union
        {
            int[__SIGEV_PAD_SIZE] _pad;
            pid_t                 _tid;

            struct
            {
                void function(sigval) sigev_notify_function;
                void*                 sigev_notify_attributes;
            }
        }
    }
}
else version (FreeBSD)
{
    struct sigevent
    {
        int             sigev_notify;
        int             sigev_signo;
        sigval          sigev_value;
        union
        {
            lwpid_t _threadid;
            struct
            {
                void function(sigval) sigev_notify_function;
                void* sigev_notify_attributes;
            }
            c_long[8] __spare__;
        }
    }
}
else version (NetBSD)
{
    struct sigevent
    {
        int             sigev_notify;
        int             sigev_signo;
        sigval          sigev_value;
        void function(sigval) sigev_notify_function;
        void /* pthread_attr_t */*sigev_notify_attributes;
    }
}
else version (OpenBSD)
{
    // OpenBSD does not implement sigevent.
    alias sigevent = void;
}
else version (DragonFlyBSD)
{
    union  _sigev_un_t
    {
        int                       sigev_signo;
        int                       sigev_notify_kqueue;
        void /*pthread_attr_t*/ * sigev_notify_attributes;
    }
    union _sigval_t
    {
        int                       sival_int;
        void                    * sival_ptr;
        int                       sigval_int;
        void                    * sigval_ptr;
    }
    struct sigevent
    {
        int                       sigev_notify;
        _sigev_un_t               sigev_un;
        _sigval_t                 sigev_value;
        void function(_sigval_t)  sigev_notify_function;
    }
}
else version (Darwin)
{
    struct sigevent
    {
        int sigev_notify;
        int sigev_signo;
        sigval sigev_value;
        void function(sigval) sigev_notify_function;
        pthread_attr_t* sigev_notify_attributes;
    }
}
else version (Solaris)
{
    struct sigevent
    {
        int sigev_notify;
        int sigev_signo;
        sigval sigev_value;
        void function(sigval) sigev_notify_function;
        pthread_attr_t* sigev_notify_attributes;
        int __sigev_pad2;
    }
}
else
{
    static assert(false, "Unsupported platform");
}

/*
int sigqueue(pid_t, int, const sigval);
int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
int sigwaitinfo(const scope sigset_t*, siginfo_t*);
*/

nothrow:
@nogc:

version (CRuntime_Glibc)
{
    int sigqueue(pid_t, int, const sigval);
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else version (FreeBSD)
{
    int sigqueue(pid_t, int, const sigval);
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else version (NetBSD)
{
    int sigqueue(pid_t, int, const sigval);
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else version (OpenBSD)
{
}
else version (DragonFlyBSD)
{
    int sigqueue(pid_t, int, const sigval);
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else version (Darwin)
{
}
else version (Solaris)
{
    int sigqueue(pid_t, int, const sigval);
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else version (CRuntime_Bionic)
{
}
else version (CRuntime_Musl)
{
    int sigqueue(pid_t, int, const sigval);
    pragma(mangle, muslRedirTime64Mangle!("sigtimedwait", "__sigtimedwait_time64"))
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else version (CRuntime_UClibc)
{
    int sigqueue(pid_t, int, const sigval);
    int sigtimedwait(const scope sigset_t*, siginfo_t*, const scope timespec*);
    int sigwaitinfo(const scope sigset_t*, siginfo_t*);
}
else
{
    static assert(false, "Unsupported platform");
}

//
// Threads (THR)
//
/*
int pthread_kill(pthread_t, int);
int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
*/

version (CRuntime_Glibc)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (Darwin)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (FreeBSD)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (NetBSD)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (OpenBSD)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (DragonFlyBSD)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (Solaris)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (CRuntime_Bionic)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (CRuntime_Musl)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
}
else version (CRuntime_UClibc)
{
    int pthread_kill(pthread_t, int);
    int pthread_sigmask(int, const scope sigset_t*, sigset_t*);
    int pthread_sigqueue(pthread_t, int, sigval);
}
else
{
    static assert(false, "Unsupported platform");
}
