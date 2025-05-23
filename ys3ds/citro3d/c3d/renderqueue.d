module ys3ds.citro3d.c3d.renderqueue;

import ys3ds.citro3d.c3d.framebuffer;
import ys3ds.ctru._3ds.gfx;
import ys3ds.ctru._3ds.gpu.enums;
import ys3ds.ctru._3ds.types;
import ys3ds.citro3d.c3d.texture;

extern (C) @nogc nothrow:

alias C3D_RenderTarget = C3D_RenderTarget_tag;

struct C3D_RenderTarget_tag
{
    C3D_RenderTarget* next;
    C3D_RenderTarget* prev;
    C3D_FrameBuf frameBuf;

    bool used;
    bool ownsColor;
    bool ownsDepth;

    bool linked;
    gfxScreen_t screen;
    gfx3dSide_t side;
    uint transferFlags;
}

// Flags for C3D_FrameBegin
enum
{
    C3D_FRAME_SYNCDRAW = BIT(0), // Perform C3D_FrameSync before checking the GPU status
    C3D_FRAME_NONBLOCK = BIT(1) // Return false instead of waiting if the GPU is busy
}

float C3D_FrameRate (float fps);
void C3D_FrameSync ();
uint C3D_FrameCounter (int id);

bool C3D_FrameBegin (ubyte flags);
bool C3D_FrameDrawOn (C3D_RenderTarget* target);
void C3D_FrameSplit (ubyte flags);
void C3D_FrameEnd (ubyte flags);

void C3D_FrameEndHook (void function (void*) hook, void* param);

float C3D_GetDrawingTime ();
float C3D_GetProcessingTime ();

union C3D_DEPTHTYPE
{
    int __i;
    GPU_DEPTHBUF __e;
}

extern (D) pragma(inline, true)
{
  auto C3D_DEPTHTYPE_OK(T)(auto ref T _x)
  {
      return _x.__i >= 0;
  }

  auto C3D_DEPTHTYPE_VAL(T)(auto ref T _x)
  {
      return _x.__e;
  }
}

C3D_RenderTarget* C3D_RenderTargetCreate (int width, int height, GPU_COLORBUF colorFmt, C3D_DEPTHTYPE depthFmt);
C3D_RenderTarget* C3D_RenderTargetCreateFromTex (C3D_Tex* tex, GPU_TEXFACE face, int level, C3D_DEPTHTYPE depthFmt);
void C3D_RenderTargetDelete (C3D_RenderTarget* target);
void C3D_RenderTargetSetOutput (C3D_RenderTarget* target, gfxScreen_t screen, gfx3dSide_t side, uint transferFlags);

extern(D) pragma(inline, true)
{
  void C3D_RenderTargetDetachOutput (C3D_RenderTarget* target)
  {
    C3D_RenderTargetSetOutput(null, target.screen, target.side, 0);
  }

  void C3D_RenderTargetClear (
      C3D_RenderTarget* target,
      C3D_ClearBits clearBits,
      uint clearColor,
      uint clearDepth)
  {
    C3D_FrameBufClear(&target.frameBuf, clearBits, clearColor, clearDepth);
  }
}
void C3D_SyncDisplayTransfer (uint* inadr, uint indim, uint* outadr, uint outdim, uint flags);
void C3D_SyncTextureCopy (uint* inadr, uint indim, uint* outadr, uint outdim, uint size, uint flags);
void C3D_SyncMemoryFill (uint* buf0a, uint buf0v, uint* buf0e, ushort control0, uint* buf1a, uint buf1v, uint* buf1e, ushort control1);
