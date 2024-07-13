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


## building

```
xmake f -p 3ds -m release -a arm --toolchain=devkitarm
xmake
```

## licenses

The headers included in the `headers` directory are licensed according to the source software.
(For devkitpro software (libctru, citro2d, citro3d), this is the Zlib license).

The bindings in the `ys3ds` directory are released under the public domain by me.

The ports of the D runtime libraries in `3ds-d-runtime` are licensed under Boost as noted there.

## other things

The `ys3ds.utility` module contains various functions potentially useful to a Dlang 3DS homebrew developer.

I suggest using the `automem` library for RAII smart pointers due to the restrictions of betterC mode.
