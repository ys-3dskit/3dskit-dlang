/**
 * @file shbin.h
 * @brief Shader binary support.
 */

import ys3ds.ctru._3ds.gpu.enums;

extern (C):

/// DVLE type.
enum DVLE_type
{
    VERTEX_SHDR = GPU_SHADER_TYPE.GPU_VERTEX_SHADER, ///< Vertex shader.
    GEOMETRY_SHDR = GPU_SHADER_TYPE.GPU_GEOMETRY_SHADER ///< Geometry shader.
}

/// Constant type.
enum DVLE_constantType
{
    DVLE_CONST_BOOL = 0x0, ///< Bool.
    DVLE_CONST_u8 = 0x1, ///< Unsigned 8-bit integer.
    DVLE_CONST_FLOAT24 = 0x2 ///< 24-bit float.
}

/// Output attribute.
enum DVLE_outputAttribute_t
{
    RESULT_POSITION = 0x0, ///< Position.
    RESULT_NORMALQUAT = 0x1, ///< Normal Quaternion.
    RESULT_COLOR = 0x2, ///< Color.
    RESULT_TEXCOORD0 = 0x3, ///< Texture coordinate 0.
    RESULT_TEXCOORD0W = 0x4, ///< Texture coordinate 0 W.
    RESULT_TEXCOORD1 = 0x5, ///< Texture coordinate 1.
    RESULT_TEXCOORD2 = 0x6, ///< Texture coordinate 2.
    RESULT_VIEW = 0x8, ///< View.
    RESULT_DUMMY = 0x9 ///< Dummy attribute (used as passthrough for geometry shader input).
}

/// Geometry shader operation modes.
enum DVLE_geoShaderMode
{
    GSH_POINT = 0, ///< Point processing mode.
    GSH_VARIABLE_PRIM = 1, ///< Variable-size primitive processing mode.
    GSH_FIXED_PRIM = 2 ///< Fixed-size primitive processing mode.
}

/// DVLP data.
struct DVLP_s
{
    uint codeSize; ///< Code size.
    uint* codeData; ///< Code data.
    uint opdescSize; ///< Operand description size.
    uint* opcdescData; ///< Operand description data.
}

/// DVLE constant entry data.
struct DVLE_constEntry_s
{
    ushort type; ///< Constant type. See @ref DVLE_constantType
    ushort id; ///< Constant ID.
    uint[4] data; ///< Constant data.
}

/// DVLE output entry data.
struct DVLE_outEntry_s
{
    ushort type; ///< Output type. See @ref DVLE_outputAttribute_t
    ushort regID; ///< Output register ID.
    ubyte mask; ///< Output mask.
    ubyte[3] unk; ///< Unknown.
}

/// DVLE uniform entry data.
struct DVLE_uniformEntry_s
{
    uint symbolOffset; ///< Symbol offset.
    ushort startReg; ///< Start register.
    ushort endReg; ///< End register.
}

/// DVLE data.
struct DVLE_s
{
    DVLE_type type; ///< DVLE type.
    bool mergeOutmaps; ///< true = merge vertex/geometry shader outmaps ('dummy' output attribute is present).
    DVLE_geoShaderMode gshMode; ///< Geometry shader operation mode.
    ubyte gshFixedVtxStart; ///< Starting float uniform register number for storing the fixed-size primitive vertex array.
    ubyte gshVariableVtxNum; ///< Number of fully-defined vertices in the variable-size primitive vertex array.
    ubyte gshFixedVtxNum; ///< Number of vertices in the fixed-size primitive vertex array.
    DVLP_s* dvlp; ///< Contained DVLPs.
    uint mainOffset; ///< Offset of the start of the main function.
    uint endmainOffset; ///< Offset of the end of the main function.
    uint constTableSize; ///< Constant table size.
    DVLE_constEntry_s* constTableData; ///< Constant table data.
    uint outTableSize; ///< Output table size.
    DVLE_outEntry_s* outTableData; ///< Output table data.
    uint uniformTableSize; ///< Uniform table size.
    DVLE_uniformEntry_s* uniformTableData; ///< Uniform table data.
    char* symbolTableData; ///< Symbol table data.
    ubyte outmapMask; ///< Output map mask.
    uint[8] outmapData; ///< Output map data.
    uint outmapMode; ///< Output map mode.
    uint outmapClock; ///< Output map attribute clock.
}

/// DVLB data.
struct DVLB_s
{
    uint numDVLE; ///< DVLE count.
    DVLP_s DVLP; ///< Primary DVLP.
    DVLE_s* DVLE; ///< Contained DVLE.
}

/**
 * @brief Parses a shader binary.
 * @param shbinData Shader binary data.
 * @param shbinSize Shader binary size.
 * @return The parsed shader binary.
 */
DVLB_s* DVLB_ParseFile (uint* shbinData, uint shbinSize);

/**
 * @brief Frees shader binary data.
 * @param dvlb DVLB to free.
 */
void DVLB_Free (DVLB_s* dvlb);

/**
 * @brief Gets a uniform register index from a shader.
 * @param dvle Shader to get the register from.
 * @param name Name of the register.
 * @return The uniform register index.
 */
byte DVLE_GetUniformRegister (DVLE_s* dvle, const(char)* name);

/**
 * @brief Generates a shader output map.
 * @param dvle Shader to generate an output map for.
 */
void DVLE_GenerateOutmap (DVLE_s* dvle);
