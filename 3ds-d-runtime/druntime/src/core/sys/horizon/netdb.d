/**
 * D header file for POSIX.
 *
 * Copyright: Copyright David Nadlinger 2011.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   David Nadlinger, Sean Kelly, Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright David Nadlinger 2011.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.netdb;

// ctru
public import ys3ds.ctru.netdb;

version (Horizon):
extern (C):
nothrow:
@nogc:

