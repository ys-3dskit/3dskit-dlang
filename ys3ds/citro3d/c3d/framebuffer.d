module ys3ds.citro3d.c3d.framebuffer;

import ys3ds.citro3d.c3d.texture;

extern (C) @nogc nothrow:

struct C3D_FrameBuf
{
    import std.bitmanip : bitfields;

    void* colorBuf;
    void* depthBuf;
    ushort width;
    ushort height;
    GPU_COLORBUF colorFmt;
    GPU_DEPTHBUF depthFmt;
    bool block32;

    mixin(bitfields!(
        ubyte, "colorMask", 4,
        ubyte, "depthMask", 4));
}

// Flags for C3D_FrameBufClear
enum C3D_ClearBits
{
    C3D_CLEAR_COLOR = BIT(0),
    C3D_CLEAR_DEPTH = BIT(1),
    C3D_CLEAR_ALL = C3D_CLEAR_COLOR | C3D_CLEAR_DEPTH
}

uint C3D_CalcColorBufSize (uint width, uint height, GPU_COLORBUF fmt);
uint C3D_CalcDepthBufSize (uint width, uint height, GPU_DEPTHBUF fmt);

C3D_FrameBuf* C3D_GetFrameBuf ();
void C3D_SetFrameBuf (C3D_FrameBuf* fb);
void C3D_FrameBufTex (C3D_FrameBuf* fb, C3D_Tex* tex, GPU_TEXFACE face, int level);
void C3D_FrameBufClear (C3D_FrameBuf* fb, C3D_ClearBits clearBits, uint clearColor, uint clearDepth);
void C3D_FrameBufTransfer (C3D_FrameBuf* fb, gfxScreen_t screen, gfx3dSide_t side, uint transferFlags);

extern(D)
{
  void C3D_FrameBufAttrib (
      C3D_FrameBuf* fb,
      ushort width,
      ushort height,
      bool block32)
  {
    fb.width = width;
    fb.height = height;
    fb.block32 = block32;
  }

  void C3D_FrameBufColor (C3D_FrameBuf* fb, void* buf, GPU_COLORBUF fmt)
  {
    fb.colorBuf = buf; // may be null
    fb.colorFmt = buf ? fmt : GPU_RB_RGBA8;
    fb.colorMask = buf ? 0xF : 0;
  }

  void C3D_FrameBufDepth (C3D_FrameBuf* fb, void* buf, GPU_DEPTHBUF fmt)
  {
    fb.depthBuf = buf; // may be null
    fb.depthFmt = buf ? fmt : GPU_RB_DEPTH24;
    fb.depthMask = buf ? (fmt == GPU_RB_DEPTH24_STENCIL8 ? 0x3 : 0x2) : 0;
  }
}
