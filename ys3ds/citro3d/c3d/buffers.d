module ys3ds.citro3d.c3d.buffers;

import ys3ds.ctru._3ds.types;
import ys3ds.citro3d.c3d.types;

extern (C) @nogc nothrow:

struct C3D_BufCfg
{
    uint offset;
    uint[2] flags;
}

struct C3D_BufInfo
{
    uint base_paddr;
    int bufCount;
    C3D_BufCfg[12] buffers;
}

void BufInfo_Init (C3D_BufInfo* info);
int BufInfo_Add (C3D_BufInfo* info, const(void)* data, ptrdiff_t stride, int attribCount, ulong permutation);

C3D_BufInfo* C3D_GetBufInfo ();
void C3D_SetBufInfo (C3D_BufInfo* info);
