module _3dsdruntime.test;

// build with
// ldc2 -c -mtriple=arm-freestanding-eabihf -float-abi=hard -mcpu=mpcore -mattr=armv6k -betterC -fvisibility=hidden -d-version=Horizon,N3DS -I/opt/devkitpro/libctru/include -I.. -Idruntime/src -oftest.o test.d

// then link with
// /opt/devkitpro/devkitARM/bin/arm-none-eabi-g++ -o test_druntime test_druntime.o

version (Horizon) {}
else
{
  version (N3DS) {}
  else static assert(0, "build with the compiler options listed in the comment above!!");
}

extern(C) void main()
{
  // should work with horizon!
  import core.stdc.stdio;
  import ys3ds.ctru._3ds.gfx : gfxInitDefault, gfxScreen_t, gfxSwapBuffers, gfxExit;
  import ys3ds.ctru._3ds.console : consoleInit;
  import ys3ds.ctru._3ds.services.apt : aptMainLoop;
  import ys3ds.ctru._3ds.services.hid : hidScanInput, hidKeysDown, KEY_START;
  import ys3ds.ctru._3ds.services.gspgpu : gspWaitForVBlank;

  gfxInitDefault();
  consoleInit(gfxScreen_t.GFX_TOP, null);

  printf("hi? maybe?");

  while (aptMainLoop()) {
    gspWaitForVBlank();
    gfxSwapBuffers();
    hidScanInput();
  }

  gfxExit();
}
