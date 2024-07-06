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
module core.sys.horizon.netinet.in_;

public import core.stdc.inttypes; // for uint32_t, uint16_t, uint8_t
public import core.sys.horizon.arpa.inet;
public import core.sys.horizon.sys.socket; // for sa_family_t

version (Horizon):
extern (C) nothrow @nogc:

// libctru
public import ys3ds.ctru.netinet.in_;
