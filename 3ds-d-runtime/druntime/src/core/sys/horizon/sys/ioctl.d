/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Alex Rønne Petersen 2011 - 2012.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Alex Rønne Petersen
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Alex Rønne Petersen 2011 - 2012.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.horizon.sys.ioctl;

version (Horizon):

extern (C) nothrow @nogc:

// ctru
public import ys3ds.ctru.sys.ioctl;
