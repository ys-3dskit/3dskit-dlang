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
module core.sys.horizon.setjmp;

import core.sys.horizon.config;
import core.sys.horizon.signal; // for sigset_t

version (Horizon):
extern (C) nothrow @nogc:

//
// Required
//
/*
jmp_buf

int  setjmp(ref jmp_buf);
void longjmp(ref jmp_buf, int);
*/

enum jmp_buf = c_long[64]; // ?

int setjmp(ref jmp_buf);
void longjmp(ref jmp_buf, int);

//
// C Extension (CX)
//
/*
sigjmp_buf

int  sigsetjmp(sigjmp_buf, int);
void siglongjmp(sigjmp_buf, int);
*/

//
// XOpen (XSI)
//
/*
int  _setjmp(jmp_buf);
void _longjmp(jmp_buf, int);
*/
