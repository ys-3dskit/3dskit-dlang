module ys3ds.citro3d.c3d.texenv;

import ys3ds.citro3d.c3d.types;
import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.gpu.enums;

extern (C) @nogc nothrow:

struct C3D_TexEnv
{
    ushort srcRgb;
    ushort srcAlpha;

    union
    {
        uint opAll;

        struct
        {
            import std.bitmanip : bitfields;

            mixin(bitfields!(
                uint, "opRgb", 12,
                uint, "opAlpha", 12,
                uint, "", 8));
        }
    }

    ushort funcRgb;
    ushort funcAlpha;
    uint color;
    ushort scaleRgb;
    ushort scaleAlpha;
}

enum C3D_TexEnvMode
{
    C3D_RGB = BIT(0),
    C3D_Alpha = BIT(1),
    C3D_Both = C3D_RGB | C3D_Alpha
}

C3D_TexEnv* C3D_GetTexEnv (int id);
void C3D_SetTexEnv (int id, C3D_TexEnv* env);
void C3D_DirtyTexEnv (C3D_TexEnv* env);

void C3D_TexEnvBufUpdate (int mode, int mask);
void C3D_TexEnvBufColor (uint color);

extern(D)
{
  void C3D_TexEnvInit (C3D_TexEnv* env)
  {
    env.srcRgb = cast(ushort) GPU_TEVSOURCES(GPU_TEVSRC.GPU_PREVIOUS, 0, 0);
    env.srcAlpha = env.srcRgb;
    env.opAll = 0;
    env.funcRgb = GPU_COMBINEFUNC.GPU_REPLACE;
    env.funcAlpha = env.funcRgb;
    env.color = 0xFFFFFFFF;
    env.scaleRgb = GPU_TEVSCALE.GPU_TEVSCALE_1;
    env.scaleAlpha = GPU_TEVSCALE.GPU_TEVSCALE_1;
  }

pragma(inline, true):

  void C3D_TexEnvSrc (
      C3D_TexEnv* env,
      C3D_TexEnvMode mode,
      GPU_TEVSRC s1,
      GPU_TEVSRC s2 = GPU_TEVSRC.GPU_PRIMARY_COLOR,
      GPU_TEVSRC s3 = GPU_TEVSRC.GPU_PRIMARY_COLOR)
  {
    int param = GPU_TEVSOURCES(cast(int) s1, cast(int) s2, cast(int) s3);
    if (cast(int)mode & C3D_TexEnvMode.C3D_RGB)
      env.srcRgb = cast(ushort)param;
    if (cast(int)mode & C3D_TexEnvMode.C3D_Alpha)
      env.srcAlpha = cast(ushort)param;
  }

  void C3D_TexEnvOpRgb (
      C3D_TexEnv* env,
      GPU_TEVOP_RGB o1,
      GPU_TEVOP_RGB o2 = GPU_TEVOP_RGB.GPU_TEVOP_RGB_SRC_COLOR,
      GPU_TEVOP_RGB o3 = GPU_TEVOP_RGB.GPU_TEVOP_RGB_SRC_COLOR)
  {
    env.opRgb = GPU_TEVOPERANDS(cast(int)o1, cast(int) o2, cast(int) o3);
  }

  void C3D_TexEnvOpAlpha (
      C3D_TexEnv* env,
      GPU_TEVOP_A o1,
      GPU_TEVOP_A o2 = GPU_TEVOP_A.GPU_TEVOP_A_SRC_ALPHA,
      GPU_TEVOP_A o3 = GPU_TEVOP_A.GPU_TEVOP_A_SRC_ALPHA)
  {
    env.opAlpha = GPU_TEVOPERANDS(cast(int)o1, cast(int)o2, cast(int)o3);
  }

  void C3D_TexEnvFunc (
      C3D_TexEnv* env,
      C3D_TexEnvMode mode,
      GPU_COMBINEFUNC param)
  {
    if(cast(int)mode & C3D_TexEnvMode.C3D_RGB)
      env.funcRgb = cast(ushort)param;
    if (cast(int) mode & C3D_TexEnvMode.C3D_Alpha)
      env.funcAlpha = cast(ushort)param;
  }

  void C3D_TexEnvColor (C3D_TexEnv* env, uint color)
  {
    env.color = color;
  }

  void C3D_TexEnvScale (C3D_TexEnv* env, int mode, GPU_TEVSCALE param)
  {
    if (cast(int) mode & C3D_TexEnvMode.C3D_RGB)
      env.scaleRgb =cast(ushort) param;
    if (cast(int) mode & C3D_TexEnvMode.C3D_Alpha)
      env.scaleAlpha = cast(ushort)param;
  }

}
