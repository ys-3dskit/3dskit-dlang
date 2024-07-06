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

import core.sys.horizon.config;
public import core.stdc.inttypes; // for uint32_t, uint16_t, uint8_t
public import core.sys.horizon.arpa.inet;
public import core.sys.horizon.sys.socket; // for sa_family_t

version (Horizon):
extern (C) nothrow @nogc:

// libctru
public import ys3ds.ctru.netinet.in_;

//
// Required
//
/*
NOTE: The following must must be defined in core.sys.posix.arpa.inet to break
      a circular import: in_port_t, in_addr_t, struct in_addr, INET_ADDRSTRLEN.

in_port_t
in_addr_t

sa_family_t // from core.sys.posix.sys.socket
uint8_t     // from core.stdc.inttypes
uint32_t    // from core.stdc.inttypes

struct in_addr
{
    in_addr_t   s_addr;
}

struct sockaddr_in
{
    sa_family_t sin_family;
    in_port_t   sin_port;
    in_addr     sin_addr;
}

IPPROTO_IP
IPPROTO_ICMP
IPPROTO_TCP
IPPROTO_UDP

INADDR_ANY
INADDR_BROADCAST

INET_ADDRSTRLEN

htonl() // from core.sys.posix.arpa.inet
htons() // from core.sys.posix.arpa.inet
ntohl() // from core.sys.posix.arpa.inet
ntohs() // from core.sys.posix.arpa.inet
*/
