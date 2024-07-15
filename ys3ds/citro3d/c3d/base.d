module ys3ds.citro3d.c3d.base;

import ys3ds.citro3d.c3d.types;
import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.gpu.enums;
import ys3ds.ctru._3ds.gpu.shaderProgram;

import ys3ds.citro3d.c3d.buffers;
import ys3ds.citro3d.c3d.maths;

extern (C) @nogc nothrow:

enum C3D_DEFAULT_CMDBUF_SIZE = 0x40000;

enum
{
    C3D_UNSIGNED_BYTE = 0,
    C3D_UNSIGNED_SHORT = 1
}

bool C3D_Init (size_t cmdBufSize);
void C3D_Fini ();

float C3D_GetCmdBufUsage ();

void C3D_BindProgram (shaderProgram_s* program);

void C3D_SetViewport (uint x, uint y, uint w, uint h);
void C3D_SetScissor (GPU_SCISSORMODE mode, uint left, uint top, uint right, uint bottom);

void C3D_DrawArrays (GPU_Primitive_t primitive, int first, int size);
void C3D_DrawElements (GPU_Primitive_t primitive, int count, int type, const(void)* indices);

// Immediate-mode vertex submission
void C3D_ImmDrawBegin (GPU_Primitive_t primitive);
void C3D_ImmSendAttrib (float x, float y, float z, float w);
void C3D_ImmDrawEnd ();

void C3D_ImmDrawRestartPrim ();

// Fixed vertex attributes
C3D_FVec* C3D_FixedAttribGetWritePtr (int id);

void C3D_FixedAttribSet (int id, float x, float y, float z, float w);
