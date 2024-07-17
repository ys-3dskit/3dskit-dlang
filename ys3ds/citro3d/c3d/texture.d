module ys3ds.citro3d.c3d.texture;

import ys3ds.citro3d.c3d.types;
import ys3ds.ctru._3ds.gpu.enums;
import ys3ds.ctru._3ds.gfx;
import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

struct C3D_TexCube
{
    void*[6] data;
}

struct C3D_Tex
{
    import std.bitmanip : bitfields;

    union
    {
        void* data;
        C3D_TexCube* cube;
    }

    mixin(bitfields!(
        GPU_TEXCOLOR, "fmt", 4,
        size_t, "size", 28));

    union
    {
        uint dim;

        struct
        {
            ushort height;
            ushort width;
        }
    }

    uint param;
    uint border;

    union
    {
        uint lodParam;

        struct
        {
            ushort lodBias;
            ubyte maxLevel;
            ubyte minLevel;
        }
    }
}

struct C3D_TexInitParams
{
    import std.bitmanip : bitfields;

    ushort width;
    ushort height;

    mixin(bitfields!(
        ubyte, "maxLevel", 4,
        GPU_TEXCOLOR, "format", 4,
        GPU_TEXTURE_MODE_PARAM, "type", 3,
        bool, "onVram", 1,
        uint, "", 4));

    // D struct initializer syntax does not work with bitfields
    pragma(inline, true)
    this(ushort _width, ushort _height, ubyte _maxLevel, GPU_TEXCOLOR _format, GPU_TEXTURE_MODE_PARAM _type, bool _onVram) @nogc nothrow
    {
      width = _width;
      height = _height;
      maxLevel = _maxLevel;
      format = _format;
      type = _type;
      onVram = _onVram;
    }
}

bool C3D_TexInitWithParams (C3D_Tex* tex, C3D_TexCube* cube, C3D_TexInitParams p);
void C3D_TexLoadImage (C3D_Tex* tex, const(void)* data, GPU_TEXFACE face, int level);
void C3D_TexGenerateMipmap (C3D_Tex* tex, GPU_TEXFACE face);
void C3D_TexBind (int unitId, C3D_Tex* tex);
void C3D_TexFlush (C3D_Tex* tex);
void C3D_TexDelete (C3D_Tex* tex);

void C3D_TexShadowParams(bool perspective, float bias);

extern(D) pragma(inline, true)
{
  int C3D_TexCalcMaxLevel (uint width, uint height)
  {
    import core.bitop : bsr;
    // __builtin_clz() = 31-bsr()
    // return (31-__builtin_clz(width < height ? width : height)) - 3;
    return (bsr(width < height ? width : height)) - 3; // avoid sizes smaller than 8
  }

  uint C3D_TexCalcLevelSize (uint size, int level)
  {
    return size >> (2 * level);
  }

  uint C3D_TexCalcTotalSize (uint size, int maxLevel)
  {
    /*
    S  = s + sr + sr^2 + sr^3 + ... + sr^n
    Sr = sr + sr^2 + sr^3 + ... + sr^(n+1)
    S-Sr = s - sr^(n+1)
    S(1-r) = s(1 - r^(n+1))
    S = s (1 - r^(n+1)) / (1-r)

    r = 1/4
    1-r = 3/4

    S = 4s (1 - (1/4)^(n+1)) / 3
    S = 4s (1 - 1/4^(n+1)) / 3
    S = (4/3) (s - s/4^(n+1))
    S = (4/3) (s - s/(1<<(2n+2)))
    S = (4/3) (s - s>>(2n+2))
    */
    return (size - C3D_TexCalcLevelSize(size, maxLevel+1)) * 4/3;
  }

  bool C3D_TexInit (
      C3D_Tex* tex,
      ushort width,
      ushort height,
      GPU_TEXCOLOR format)
  {
    return C3D_TexInitWithParams(
      tex,
      null,
      C3D_TexInitParams(width, height, 0, format, GPU_TEXTURE_MODE_PARAM.GPU_TEX_2D, false)
    );
  }

  bool C3D_TexInitMipmap (
      C3D_Tex* tex,
      ushort width,
      ushort height,
      GPU_TEXCOLOR format)
  {
    return C3D_TexInitWithParams(
      tex,
      null,
      C3D_TexInitParams(
        width,
        height,
        cast(ubyte)C3D_TexCalcMaxLevel(width, height),
        format,
        GPU_TEXTURE_MODE_PARAM.GPU_TEX_2D,
        false
      )
    );
  }

  bool C3D_TexInitCube (
      C3D_Tex* tex,
      C3D_TexCube* cube,
      ushort width,
      ushort height,
      GPU_TEXCOLOR format)
  {
    return C3D_TexInitWithParams(
      tex,
      null,
      C3D_TexInitParams(width, height, 0, format, GPU_TEXTURE_MODE_PARAM.GPU_TEX_CUBE_MAP, false)
    );
  }

  bool C3D_TexInitVRAM (
      C3D_Tex* tex,
      ushort width,
      ushort height,
      GPU_TEXCOLOR format)
  {
    return C3D_TexInitWithParams(
      tex,
      null,
      C3D_TexInitParams(width, height, 0, format, GPU_TEXTURE_MODE_PARAM.GPU_TEX_2D, true)
    );
  }

  bool C3D_TexInitShadow (C3D_Tex* tex, ushort width, ushort height)
  {
    return C3D_TexInitWithParams(
      tex,
      null,
      C3D_TexInitParams(width, height, 0, GPU_TEXCOLOR.GPU_RGBA8, GPU_TEXTURE_MODE_PARAM.GPU_TEX_SHADOW_2D, true)
    );
  }

  bool C3D_TexInitShadowCube (
      C3D_Tex* tex,
      C3D_TexCube* cube,
      ushort width,
      ushort height)
  {
    return C3D_TexInitWithParams(
      tex,
      cube,
      C3D_TexInitParams(width, height, 0, GPU_TEXCOLOR.GPU_RGBA8, GPU_TEXTURE_MODE_PARAM.GPU_TEX_SHADOW_CUBE, true)
    );
  }

  GPU_TEXTURE_MODE_PARAM C3D_TexGetType (C3D_Tex* tex)
  {
    return cast(GPU_TEXTURE_MODE_PARAM) ((tex.param >> 28) & 0x7);
  }

  void* C3D_TexGetImagePtr (C3D_Tex* tex, void* data, int level, uint* size)
  {
    if (size) *size = level >= 0 ? C3D_TexCalcLevelSize(tex.size, level) : 0;
    if (!level) return data;
    return cast(ubyte*) data + (level > 0 ? C3D_TexCalcTotalSize(tex.size, level-1): 0);
  }

  void* C3D_Tex2DGetImagePtr (C3D_Tex* tex, int level, uint* size)
  {
    return C3D_TexGetImagePtr(tex, tex.data, level, size);
  }

  void* C3D_TexCubeGetImagePtr (
      C3D_Tex* tex,
      GPU_TEXFACE face,
      int level,
      uint* size)
  {
    return C3D_TexGetImagePtr(tex, tex.cube.data[face], level, size);
  }

  void C3D_TexUpload (C3D_Tex* tex, const(void)* data)
  {
    C3D_TexLoadImage(tex, data, GPU_TEXFACE.GPU_TEXFACE_2D, 0);
  }

  void C3D_TexSetFilter (
      C3D_Tex* tex,
      GPU_TEXTURE_FILTER_PARAM magFilter,
      GPU_TEXTURE_FILTER_PARAM minFilter)
  {
    tex.param &= ~(GPU_TEXTURE_MAG_FILTER(GPU_TEXTURE_FILTER_PARAM.GPU_LINEAR) | GPU_TEXTURE_MIN_FILTER(GPU_TEXTURE_FILTER_PARAM.GPU_LINEAR));
    tex.param |= GPU_TEXTURE_MAG_FILTER(magFilter) | GPU_TEXTURE_MIN_FILTER(minFilter);
  }

  void C3D_TexSetFilterMipmap (C3D_Tex* tex, GPU_TEXTURE_FILTER_PARAM filter)
  {
    tex.param &= ~GPU_TEXTURE_MIP_FILTER(GPU_TEXTURE_FILTER_PARAM.GPU_LINEAR);
    tex.param |= GPU_TEXTURE_MIP_FILTER(filter);
  }

  void C3D_TexSetWrap (
      C3D_Tex* tex,
      GPU_TEXTURE_WRAP_PARAM wrapS,
      GPU_TEXTURE_WRAP_PARAM wrapT)
  {
    tex.param &= ~(GPU_TEXTURE_WRAP_S(3) | GPU_TEXTURE_WRAP_T(3));
    tex.param |= GPU_TEXTURE_WRAP_S(wrapS) | GPU_TEXTURE_WRAP_T(wrapT);
  }

  void C3D_TexSetLodBias (C3D_Tex* tex, float lodBias)
  {
    int iLodBias = cast(int) (lodBias * 0x100);
    if (iLodBias > 0xFFF)
      iLodBias = 0xFFF;
    else if (iLodBias < -0x1000)
      iLodBias = -0x1000;

    tex.lodBias = iLodBias & 0x1FFF;
  }
}
