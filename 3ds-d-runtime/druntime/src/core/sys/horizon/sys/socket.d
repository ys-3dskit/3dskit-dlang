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
module core.sys.horizon.sys.socket;

import core.sys.horizon.config;
// ctru sys.socket defines ssize_t
//public import core.sys.horizon.sys.types; // for ssize_t
// not needed, no uio
//public import core.sys.horizon.sys.uio;   // for iovec

version (Horizon):
extern (C) nothrow @nogc:

// ctru
public import ys3ds.ctru.sys.socket;
