// build with:
// ldc2 -c -g -mtriple=arm-freestanding-eabihf -float-abi=hard -mcpu=mpcore -mattr=armv6k -betterC -fvisibility=hidden -d-version=Horizon,N3DS --conf= -I. -I3ds-d-runtime/druntime/src -I3ds-d-runtime/phobos -oftest.o test.d

// then link with:
// /opt/devkitpro/devkitARM/bin/arm-none-eabi-g++ -o test test.o build/3ds/arm/release/libys3ds-dlang.a -L/opt/devkitpro/libctru/lib -Wl,-S -lctrud -lctru -lm -specs=3dsx.specs -g -march=armv6k -mtune=mpcore -mtp=soft -mfloat-abi=hard

// then build a 3dsx for testing:
// /opt/devkitpro/tools/bin/smdhtool --create "3dskit-dlang test" "A test application to make sure the runtime, phobos, and bindings work" "YS" /opt/devkitpro/libctru/default_icon.png test.smdh
// /opt/devkitpro/tools/bin/3dsxtool test test.3dsx --smdh=test.smdh
// citra test.3dsx

module test;

version (Horizon) {}
else
{
  version (N3DS) {}
  else static assert(0, "build with the compiler options listed in the comment above!!");
}

extern(C) void main()
{
  import core.stdc.stdio;
  import ys3ds.ctru._3ds.gfx : gfxInitDefault, gfxScreen_t, gfxSwapBuffers, gfxExit;
  import ys3ds.ctru._3ds.console : consoleInit, consoleClear;
  import ys3ds.ctru._3ds.services.apt : aptMainLoop;
  import ys3ds.ctru._3ds.services.hid : hidScanInput, hidKeysDown, KEY_START;
  import ys3ds.ctru._3ds.services.gspgpu : gspWaitForVBlank;
  import ys3ds.utility : toStringzManaged;

  import btl.string : String;

  import core.time : MonoTime;

  auto last = MonoTime.currTime;

  gfxInitDefault();
  consoleInit(gfxScreen_t.GFX_TOP, null);

  while (aptMainLoop()) {
    gspWaitForVBlank();
    gfxSwapBuffers();
    hidScanInput();

    consoleClear();

    auto thisTime = MonoTime.currTime;
    auto duration = thisTime - last;
    last = thisTime;

    String str;

    duration.toString((string s) { str.append(s); });

    printf("took: %s\n", toStringzManaged(str).ptr);
  }

  gfxExit();
}
