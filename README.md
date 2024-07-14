# ys-3dskit D language bindings

D language bindings for 3ds homebrew development.

Install from the xmake repo and import as so:

```d
// #include <3ds.h>
import ys3ds.ctru;

// #include <citro2d.h>
import ys3ds.citro2d;
```

C headers manually edited -> [DStep](https://github.com/jacob-carlborg/dstep) -> Manually tweaked D module.

## D runtime and standard library

This distribution contains ported versions of the D Runtime, core library, and standard library (phobos).

More information on these can be found in the 3ds-d-runtime directory.

## BTL and other included pieces

The `ys3ds.utility` module contains various functions potentially useful to a Dlang 3DS homebrew developer.

The [BTL](https://github.com/submada/btl) library is included with this distribution, to aid in memory management.
This is licensed under the Boost Software License and is included unmodified due to issues with package management.

BTL Tips:
- For C++ developers: You should recognise `btl.automem.UniquePtr` and `btl.automem.SharedPtr`. Have fun.
- For Rust developers: `UniquePtr` is basically your `Box<T>` and `SharedPtr` is like your `Rc<T>`.
- Use the hell out of `btl.string.String`! It's great!
- If the only memory allocation in your code is happening via BTL and not via `malloc`, you're probably not leaking!

## building

```
xmake f -p 3ds -m release -a arm --toolchain=devkitarm
xmake
```

## licenses

The headers included in the `headers` directory are licensed according to the source software.
(For devkitpro software (libctru, citro2d, citro3d), this is the Zlib license).

The bindings in the `ys3ds` directory are released under the public domain by me.

The ports of the D runtime libraries in `3ds-d-runtime` are licensed under Boost as noted there, as is BTL.

