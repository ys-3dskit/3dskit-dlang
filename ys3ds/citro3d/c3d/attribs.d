module ys3ds.citro3d.c3d.attribs;

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.gpu.enums;
import ys3ds.citro3d.c3d.types;

extern (C) @nogc nothrow:

struct C3D_AttrInfo
{
    uint[2] flags;
    ulong permutation;
    int attrCount;
}

void AttrInfo_Init (C3D_AttrInfo* info);
int AttrInfo_AddLoader (C3D_AttrInfo* info, int regId, GPU_FORMATS format, int count);
int AttrInfo_AddFixed (C3D_AttrInfo* info, int regId);

C3D_AttrInfo* C3D_GetAttrInfo ();
void C3D_SetAttrInfo (C3D_AttrInfo* info);
