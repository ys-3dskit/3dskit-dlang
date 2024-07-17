module ys3ds.citro3d.c3d.uniforms;

import ys3ds.citro3d.c3d.maths;
import ys3ds.citro3d.c3d.types;
import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.gpu.enums;

extern (C) @nogc nothrow:

enum C3D_FVUNIF_COUNT = 96;
enum C3D_IVUNIF_COUNT = 4;

extern __gshared C3D_FVec[C3D_FVUNIF_COUNT][2] C3D_FVUnif;
extern __gshared C3D_IVec[C3D_IVUNIF_COUNT][2] C3D_IVUnif;
extern __gshared ushort[2] C3D_BoolUnifs;

extern __gshared bool[C3D_FVUNIF_COUNT][2] C3D_FVUnifDirty;
extern __gshared bool[C3D_IVUNIF_COUNT][2] C3D_IVUnifDirty;
extern __gshared bool[2] C3D_BoolUnifsDirty;

extern(D)
{
  C3D_FVec* C3D_FVUnifWritePtr (GPU_SHADER_TYPE type, int id, int size)
  {
    for (int i = 0; i < size; i++)
      C3D_FVUnifDirty[type][id+i] = true;

    return &C3D_FVUnif[type][id];
  }

  C3D_IVec* C3D_IVUnifWritePtr (GPU_SHADER_TYPE type, int id)
  {
    id -= 0x60;
    C3D_IVUnifDirty[type][id] = true;
    return &C3D_IVUnif[type][id];
  }

  // Struct copy.
  void C3D_FVUnifMtxNx4 (
      GPU_SHADER_TYPE type,
      int id,
      const(C3D_Mtx)* mtx,
      int num)
  {
    C3D_FVec* ptr = C3D_FVUnifWritePtr(type, id, num);
    for (int i = 0; i < num; i++)
      ptr[i] = mtx.r[i];
  }

  pragma(inline, true)
  {
    void C3D_FVUnifMtx4x4 (GPU_SHADER_TYPE type, int id, const(C3D_Mtx)* mtx)
    {
      C3D_FVUnifMtxNx4(type, id, mtx, 4);
    }

    void C3D_FVUnifMtx3x4 (GPU_SHADER_TYPE type, int id, const(C3D_Mtx)* mtx)
    {
      C3D_FVUnifMtxNx4(type, id, mtx, 3);
    }

    void C3D_FVUnifMtx2x4 (GPU_SHADER_TYPE type, int id, const(C3D_Mtx)* mtx)
    {
      C3D_FVUnifMtxNx4(type, id, mtx, 2);
    }
  }

  void C3D_FVUnifSet (
      GPU_SHADER_TYPE type,
      int id,
      float x,
      float y,
      float z,
      float w)
  {
    C3D_FVec* ptr = C3D_FVUnifWritePtr(type, id, 1);
    ptr.x = x;
    ptr.y = y;
    ptr.z = z;
    ptr.w = w;
  }

  void C3D_IVUnifSet (GPU_SHADER_TYPE type, int id, int x, int y, int z, int w)
  {
    C3D_IVec* ptr = C3D_IVUnifWritePtr(type, id);
    *ptr = IVec_Pack(cast(ubyte)x, cast(ubyte)y, cast(ubyte)z, cast(ubyte)w);
  }

  void C3D_BoolUnifSet (GPU_SHADER_TYPE type, int id, bool value)
  {
    id -= 0x68;
    C3D_BoolUnifsDirty[type] = true;
    if (value)
      C3D_BoolUnifs[type] |= BIT(id);
    else C3D_BoolUnifs[type] &= ~BIT(id);
  }
}

void C3D_UpdateUniforms (GPU_SHADER_TYPE type);
