# ys-3dskit d runtime

A port of libphobos2-ldc and druntime-ldc to the 3ds platform.

This is forked off of
 - druntime: ldc-developers/ldc @ v1.39.0 (ff7954c)
 - phobos: ldc-developers/phobos @ ldc-v1.39.0 (654241b)

(compliant to D 2.109.0)

Based on source available [here](https://github.com/ldc-developers/ldc/tree/master/runtime).

Phobos (`std`) and Druntime (`core`, `rt`) are licensed under the Boost Software License, as is this port.

The `etc` portion of phobos is excluded.

## changes

note that the toolchain is running in betterC mode which means
- no GC
  * only stdlib functions that are `@nogc` will work
- no runtime reflection
- no classes
- no `core.thread` etc
- no language-supported dynamic arrays (`~` op)
- no associative arrays (hash maps)
- no exceptions (assert() failures still work via libc)
- no synchronized or `core.sync`
- no static module constructors and destructors (`static this()`, `pragma(crt_constructor)` works fine)

druntime:
- druntime now depends on the libctru bindings.
- disabling of some modules that won't work on the 3DS
  * `core.atomic` - atomic ops aren't a thing on its cpu
  * `core.cpuid` - this module only worked for x86 and IA-64
  * `core.factory` - factory is irrelevant when classes are disabled (betterC)
  * `core.runtime` - the d runtime is disabled (betterC)
  * `core.simd` - simd isn't a thing on its cpu
- adding Horizon support to many modules
  * `core.time` - MonoTime is implemented using cpu ticks
- adding `core.sys.horizon`, and removing irrelevant `core.sys` modules
  * note that the 3DS does not count as `version (Posix)` as this would require compiler patches.
- adding devkitARM/3DS bindings for `core.stdc`

phobos:
 - //TODO
