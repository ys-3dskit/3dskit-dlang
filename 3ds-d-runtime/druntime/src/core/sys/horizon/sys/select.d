/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2016.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly, Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */
module core.sys.horizon.sys.select;

import core.sys.horizon.config;
public import core.stdc.time;           // for timespec
public import core.sys.horizon.sys.time;  // for timeval
public import core.sys.horizon.sys.types; // for time_t
public import core.sys.horizon.signal;    // for sigset_t

//debug=select;  // uncomment to turn on debugging printf's

version (Horizon):
extern (C) nothrow @nogc:

//
// Required
//
/*
NOTE: This module requires timeval from core.sys.posix.sys.time, but timeval
      is supposedly an XOpen extension.  As a result, this header will not
      compile on platforms that are not XSI-compliant.  This must be resolved
      on a per-platform basis.

fd_set

void FD_CLR(int fd, fd_set* fdset);
int FD_ISSET(int fd, const(fd_set)* fdset);
void FD_SET(int fd, fd_set* fdset);
void FD_ZERO(fd_set* fdset);

FD_SETSIZE

int  pselect(int, fd_set*, fd_set*, fd_set*, const scope timespec*, const scope sigset_t*);
int  select(int, fd_set*, fd_set*, fd_set*, timeval*);
*/

// dkp sys/select.h

private alias __fd_mask = c_ulong;
private enum _NFDBITS = __fd_mask.sizeof * 8;

enum uint FD_SETSIZE = 64;

struct fd_set
{
  __fd_mask[(FD_SETSIZE + (_NFDBITS - 1)) / _NFDBITS] __fds_bits;
}

extern (D) pure // macros
{
  __fd_mask __fdset_mask(uint n)
  {
    return cast(__fd_mask) 1 << (n % _NFDBITS);
  }

  void FD_CLR(int n, fd_set* p)
  {
    p.fds_bits[n / _NFDBITS] &= ~__fdset_mask(n);
  }

  void FD_COPY(fd_set* f, fd_set* t)
  {
    *t = *f;
  }

  bool FD_ISSET(int n, const(fd_set)* p)
  {
    return (p.fds_bits[n / _NFDBITS] & __fdset_mask(n)) != 0;
  }

  void FD_SET(int n, fd_set* p)
  {
    p.fds_bits[n / _NFDBITS] |= __fdset_mask(n);
  }

  void FD_ZERO(fd_set* p)
  {
    fd_set* _p;
    size_t _n;

    _p = p;
    _n = (FD_SETSIZE + (_NFDBITS - 1)) / _NFDBITS;
    while (_n > 0)
      _p.fds_bits[--_n] = 0;
  }
}

int select(int __n, fd_set* __readfds, fd_set* __writefds, fd_set* __exceptfds, timeval* __timeout);
int pselect(int __n, fd_set* __readfds, fd_set* __writefds, fd_set* __exceptfds, const scope timeval* __timeout, const scope sigset_t* __set);
