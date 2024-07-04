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

This will not compile a library, but will leave object files in `build/.objs`.