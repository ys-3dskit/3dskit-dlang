/**
 * D header file for POSIX.
 *
 * Copyright: Copyright (c) 2013 Lars Tandle Kyllingstad.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Lars Tandle Kyllingstad
 * Standards: The Open Group Base Specifications Issue 7, IEEE Std 1003.1-2008
 */
module core.sys.horizon.sys.resource;
version (Horizon):

public import core.sys.horizon.sys.time;
public import core.sys.horizon.sys.types: id_t;
import core.sys.horizon.config;

nothrow @nogc extern(C):

// dkp sys/resource.h

enum
{
  RUSAGE_SELF = 0,
  RUSAGE_CHILDREN = 1
}

struct rusage
{
  timeval ru_utime;
  timeval ru_stime;
}

int getrusage(int, rusage*);
