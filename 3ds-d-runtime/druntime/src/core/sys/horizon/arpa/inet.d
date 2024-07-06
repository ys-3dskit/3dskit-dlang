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
module core.sys.horizon.arpa.inet;

version (Horizon):

// use libctru to polyfill `core`
public import ys3ds.ctru.arpa.inet;

/*
NOTE: The following must must be defined in core.sys.posix.arpa.inet to break
      a circular import: INET6_ADDRSTRLEN.

INET6_ADDRSTRLEN // from core.sys.posix.netinet.in_
*/

enum INET_ADDRSTRLEN  = 16;
