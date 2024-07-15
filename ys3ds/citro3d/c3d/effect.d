module ys3ds.citro3d.c3d.effect;

import ys3ds.ctru._3ds.gpu.enums;
import ys3ds.citro3d.c3d.types;

extern (C) @nogc nothrow:

void C3D_DepthMap (bool bIsZBuffer, float zScale, float zOffset);
void C3D_CullFace (GPU_CULLMODE mode);
void C3D_StencilTest (bool enable, GPU_TESTFUNC function_, int ref_, int inputMask, int writeMask);
void C3D_StencilOp (GPU_STENCILOP sfail, GPU_STENCILOP dfail, GPU_STENCILOP pass);
void C3D_BlendingColor (uint color);
void C3D_EarlyDepthTest (bool enable, GPU_EARLYDEPTHFUNC function_, uint ref_);
void C3D_DepthTest (bool enable, GPU_TESTFUNC function_, GPU_WRITEMASK writemask);
void C3D_AlphaTest (bool enable, GPU_TESTFUNC function_, int ref_);
void C3D_AlphaBlend (GPU_BLENDEQUATION colorEq, GPU_BLENDEQUATION alphaEq, GPU_BLENDFACTOR srcClr, GPU_BLENDFACTOR dstClr, GPU_BLENDFACTOR srcAlpha, GPU_BLENDFACTOR dstAlpha);
void C3D_ColorLogicOp (GPU_LOGICOP op);
void C3D_FragOpMode (GPU_FRAGOPMODE mode);
void C3D_FragOpShadow (float scale, float bias);
