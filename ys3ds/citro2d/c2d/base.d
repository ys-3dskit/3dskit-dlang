module ys3ds.citro2d.c2d.base;

import ys3ds.citro3d;
import ys3ds.citro3d.tex3ds;
import ys3ds.ctru._3ds.gfx;

/**
 * @file base.h
 * @brief Basic citro2d initialization and drawing API
 */

extern (C) @nogc nothrow:

enum C2D_DEFAULT_MAX_OBJECTS = 4096;

struct C2D_DrawParams
{
    struct _Anonymous_0
    {
        float x;
        float y;
        float w;
        float h;
    }

    _Anonymous_0 pos;

    struct _Anonymous_1
    {
        float x;
        float y;
    }

    _Anonymous_1 center;

    float depth;
    float angle;
}

enum C2D_TintMode
{
    C2D_TintSolid = 0, ///< Plain solid tint color
    C2D_TintMult = 1, ///< Tint color multiplied by texture color
    C2D_TintLuma = 2 ///< Tint color multiplied by grayscale converted texture color
}

struct C2D_Tint
{
    uint color; ///< RGB tint color and Alpha transparency
    float blend; ///< Blending strength of the tint color (0.0~1.0)
}

enum C2D_Corner
{
    C2D_TopLeft = 0, ///< Top left corner
    C2D_TopRight = 1, ///< Top right corner
    C2D_BotLeft = 2, ///< Bottom left corner
    C2D_BotRight = 3 ///< Bottom right corner
}

struct C2D_Image
{
    C3D_Tex* tex;
    const(Tex3DS_SubTexture)* subtex;
}

struct C2D_ImageTint
{
    C2D_Tint[4] corners;
}

/** @defgroup Helper Helper functions
 *  @{
 */

extern(D) pragma(inline, true)
{
  /** @brief Clamps a value between bounds
  *  @param[in] x The value to clamp
  *  @param[in] min The lower bound
  *  @param[in] max The upper bound
  *  @returns The clamped value
  */
  float C2D_Clamp (float x, float min, float max)
  {
    return x <= min ? min : x >= max ? max : x;
  }

  /** @brief Converts a float to u8
  *  @param[in] x Input value (0.0~1.0)
  *  @returns Output value (0~255)
  */
  ubyte C2D_FloatToU8 (float x)
  {
    return cast(ubyte) (255.0f * C2D_Clamp(x, 0.0f, 1.0f)+0.5f);
  }

  /** @brief Builds a 32-bit RGBA color value
  *  @param[in] r Red component (0~255)
  *  @param[in] g Green component (0~255)
  *  @param[in] b Blue component (0~255)
  *  @param[in] a Alpha component (0~255)
  *  @returns The 32-bit RGBA color value
  */
  uint C2D_Color32 (ubyte r, ubyte g, ubyte b, ubyte a)
  {
    return r | (g << 8) | (b << 16) | (a << 24);
  }

  /** @brief Builds a 32-bit RGBA color value from float values
  *  @param[in] r Red component (0.0~1.0)
  *  @param[in] g Green component (0.0~1.0)
  *  @param[in] b Blue component (0.0~1.0)
  *  @param[in] a Alpha component (0.0~1.0)
  *  @returns The 32-bit RGBA color value
  */
  uint C2D_Color32f (float r, float g, float b, float a)
  {
    return C2D_Color32(C2D_FloatToU8(r), C2D_FloatToU8(g), C2D_FloatToU8(b), C2D_FloatToU8(a));
  }

  /** @brief Configures one corner of an image tint structure
  *  @param[in] tint Image tint structure
  *  @param[in] corner The corner of the image to tint
  *  @param[in] color RGB tint color and Alpha transparency
  *  @param[in] blend Blending strength of the tint color (0.0~1.0)
  */
  void C2D_SetImageTint (
      C2D_ImageTint* tint,
      C2D_Corner corner,
      uint color,
      float blend)
  {
    tint.corners[corner].color = color;
    tint.corners[corner].blend = blend;
  }

  /** @brief Configures an image tint structure with the specified tint parameters applied to all corners
  *  @param[in] tint Image tint structure
  *  @param[in] color RGB tint color and Alpha transparency
  *  @param[in] blend Blending strength of the tint color (0.0~1.0)
  */
  void C2D_PlainImageTint (C2D_ImageTint* tint, uint color, float blend)
  {
    C2D_SetImageTint(tint, C2D_Corner.C2D_TopLeft, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_TopRight, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_BotLeft, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_BotRight, color, blend);
  }

  /** @brief Configures an image tint structure to just apply transparency to the image
  *  @param[in] tint Image tint structure
  *  @param[in] alpha Alpha transparency value to apply to the image
  */
  void C2D_AlphaImageTint (C2D_ImageTint* tint, float alpha)
  {
    C2D_PlainImageTint(tint, C2D_Color32f(0.0f, 0.0f, 0.0f, alpha), 0.0f);
  }

  /** @brief Configures an image tint structure with the specified tint parameters applied to the top side (e.g. for gradients)
  *  @param[in] tint Image tint structure
  *  @param[in] color RGB tint color and Alpha transparency
  *  @param[in] blend Blending strength of the tint color (0.0~1.0)
  */
  void C2D_TopImageTint (C2D_ImageTint* tint, uint color, float blend)
  {
    C2D_SetImageTint(tint, C2D_Corner.C2D_TopLeft, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_TopRight, color, blend);
  }

  /** @brief Configures an image tint structure with the specified tint parameters applied to the bottom side (e.g. for gradients)
  *  @param[in] tint Image tint structure
  *  @param[in] color RGB tint color and Alpha transparency
  *  @param[in] blend Blending strength of the tint color (0.0~1.0)
  */
  void C2D_BottomImageTint (C2D_ImageTint* tint, uint color, float blend)
  {
    C2D_SetImageTint(tint, C2D_Corner.C2D_BotLeft, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_BotRight, color, blend);
  }

  /** @brief Configures an image tint structure with the specified tint parameters applied to the left side (e.g. for gradients)
  *  @param[in] tint Image tint structure
  *  @param[in] color RGB tint color and Alpha transparency
  *  @param[in] blend Blending strength of the tint color (0.0~1.0)
  */
  void C2D_LeftImageTint (C2D_ImageTint* tint, uint color, float blend)
  {
    C2D_SetImageTint(tint, C2D_Corner.C2D_TopLeft, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_BotLeft, color, blend);
  }

  /** @brief Configures an image tint structure with the specified tint parameters applied to the right side (e.g. for gradients)
  *  @param[in] tint Image tint structure
  *  @param[in] color RGB tint color and Alpha transparency
  *  @param[in] blend Blending strength of the tint color (0.0~1.0)
  */
  void C2D_RightImageTint (C2D_ImageTint* tint, uint color, float blend)
  {
    C2D_SetImageTint(tint, C2D_Corner.C2D_TopRight, color, blend);
    C2D_SetImageTint(tint, C2D_Corner.C2D_BotRight, color, blend);
  }
}
/** @} */

/** @defgroup Base Basic functions
 *  @{
 */

/** @brief Initialize citro2d
 *  @param[in] maxObjects Maximum number of 2D objects that can be drawn per frame.
 *  @remarks Pass C2D_DEFAULT_MAX_OBJECTS as a starting point.
 *  @returns true on success, false on failure
 */
bool C2D_Init (size_t maxObjects);

/** @brief Deinitialize citro2d */
void C2D_Fini ();

/** @brief Prepares the GPU for rendering 2D content
 *  @remarks This needs to be done only once in the program if citro2d is the sole user of the GPU.
 */
void C2D_Prepare ();

/** @brief Ensures all 2D objects so far have been drawn */
void C2D_Flush ();

/** @brief Configures the size of the 2D scene.
 *  @param[in] width The width of the scene, in pixels.
 *  @param[in] height The height of the scene, in pixels.
 *  @param[in] tilt Whether the scene is tilted like the 3DS's sideways screens.
 */
void C2D_SceneSize (uint width, uint height, bool tilt);

/** @brief Configures the size of the 2D scene to match that of the specified render target.
 *  @param[in] target Render target
 */
extern(D) pragma(inline, true)
void C2D_SceneTarget (C3D_RenderTarget* target)
{
  C2D_SceneSize(target.frameBuf.width, target.frameBuf.height, target.linked);
}

/** @brief Resets the model transformation matrix. */
void C2D_ViewReset ();

/** @brief Saves the current model transformation matrix.
 * @param[out] matrix Pointer to save the current matrix to
 */
void C2D_ViewSave (C3D_Mtx* matrix);

/** @brief Restores a previously saved model transformation matrix.
 * @param[in] matrix Pointer to matrix to restor
 */
void C2D_ViewRestore (const(C3D_Mtx)* matrix);

/** @brief Translates everything drawn via the model matrix.
 * @param[in] x Translation in the x direction
 * @param[in] y Translation in the y direction
 */
void C2D_ViewTranslate (float x, float y);

/** @brief Rotates everything drawn via the model matrix.
 * @param[in] rotation Rotation in the counterclockwise direction in radians
 */
void C2D_ViewRotate (float rotation);

/** @brief Rotates everything drawn via the model matrix.
 * @param[in] rotation Rotation in the counterclockwise direction in degrees
 */
extern (D) pragma(inline, true)
void C2D_ViewRotateDegrees (float rotation)
{
  C2D_ViewRotate(C3D_AngleFromDegrees(rotation));
}

/** @brief Shears everything drawn via the model matrix.
 * @param[in] x Shear factor in the x direction
 * @param[in] y Shear factor in the y direction
 */
void C2D_ViewShear (float x, float y);

/** @brief Scales everything drawn via the model matrix.
 * @param[in] x Scale factor in the x direction
 * @param[in] y Scale factor in the y direction
 */
void C2D_ViewScale (float x, float y);

/** @brief Helper function to create a render target for a screen
 *  @param[in] screen Screen (GFX_TOP or GFX_BOTTOM)
 *  @param[in] side Side (GFX_LEFT or GFX_RIGHT)
 *  @returns citro3d render target object
 */
C3D_RenderTarget* C2D_CreateScreenTarget (gfxScreen_t screen, gfx3dSide_t side);

/** @brief Helper function to clear a rendertarget using the specified color
 *  @param[in] target Render target to clear
 *  @param[in] color 32-bit RGBA color value to fill the target with
 */
void C2D_TargetClear (C3D_RenderTarget* target, uint color);

/** @brief Helper function to begin drawing a 2D scene on a render target
 *  @param[in] target Render target to draw the 2D scene to
 */
extern (D) pragma(inline, true)
void C2D_SceneBegin (C3D_RenderTarget* target)
{
  C2D_Flush();
  C3D_FrameDrawOn(target);
  C2D_SceneTarget(target);
}

/** @} */

/** @defgroup Env Drawing environment functions
 *  @{
 */

/** @brief Configures the fading color
 *  @param[in] color 32-bit RGBA color value to be used as the fading color (0 by default)
 *  @remark The alpha component of the color is used as the strength of the fading color.
 *          If alpha is zero, the fading color has no effect. If it is the highest value,
 *          the rendered pixels will all have the fading color. Everything inbetween is
 *          rendered as a blend of the original pixel color and the fading color.
 */
void C2D_Fade (uint color);

/** @brief Configures the formula used to calculate the tinted texture color
 *  @param[in] mode Tinting mode
 *  @remark Texture tinting works by linearly interpolating between the regular texture color
 *          and the tinted texture color according to the blending strength parameter.
 *          This function can be used to change how the tinted texture color is precisely
 *          calculated, refer to \ref C2D_TintMode for a list of available tinting modes.
 */
void C2D_SetTintMode (C2D_TintMode mode);

/** @} */

/** @defgroup Drawing Drawing functions
 *  @{
 */

/** @brief Draws an image using the GPU (variant accepting C2D_DrawParams)
 *  @param[in] img Handle of the image to draw
 *  @param[in] params Parameters with which to draw the image
 *  @param[in] tint Tint parameters to apply to the image (optional, can be null)
 *  @returns true on success, false on failure
 */
bool C2D_DrawImage (C2D_Image img, const(C2D_DrawParams)* params, const(C2D_ImageTint)* tint);

/** @brief Draws an image using the GPU (variant accepting position/scaling)
 *  @param[in] img Handle of the image to draw
 *  @param[in] x X coordinate at which to place the top left corner of the image
 *  @param[in] y Y coordinate at which to place the top left corner of the image
 *  @param[in] depth Depth value to draw the image with
 *  @param[in] tint Tint parameters to apply to the image (optional, can be null)
 *  @param[in] scaleX Horizontal scaling factor to apply to the image (optional, by default 1.0f); negative values apply a horizontal flip
 *  @param[in] scaleY Vertical scaling factor to apply to the image (optional, by default 1.0f); negative values apply a vertical flip
 */
extern(D) bool C2D_DrawImageAt (
    C2D_Image img,
    float x,
    float y,
    float depth,
    const(C2D_ImageTint)* tint = null,
    float scaleX = 1,
    float scaleY = 1)
{
  auto params = C2D_DrawParams(
    C2D_DrawParams._Anonymous_0(x, y, scaleX * img.subtex.width, scaleY * img.subtex.height),
    C2D_DrawParams._Anonymous_1(0, 0),
    depth,
    0.0f
  );
  return C2D_DrawImage(img, &params, tint);
}

/** @brief Draws an image using the GPU (variant accepting position/scaling/rotation)
 *  @param[in] img Handle of the image to draw
 *  @param[in] x X coordinate at which to place the center of the image
 *  @param[in] y Y coordinate at which to place the center of the image
 *  @param[in] depth Depth value to draw the image with
 *  @param[in] angle Angle (in radians) to rotate the image by, counter-clockwise
 *  @param[in] tint Tint parameters to apply to the image (optional, can be null)
 *  @param[in] scaleX Horizontal scaling factor to apply to the image (optional, by default 1.0f); negative values apply a horizontal flip
 *  @param[in] scaleY Vertical scaling factor to apply to the image (optional, by default 1.0f); negative values apply a vertical flip
 */
extern(D) bool C2D_DrawImageAtRotated (
    C2D_Image img,
    float x,
    float y,
    float depth,
    float angle,
    const(C2D_ImageTint)* tint = null,
    float scaleX = 1,
    float scaleY = 1)
{
  auto params = C2D_DrawParams(
    C2D_DrawParams._Anonymous_0(x, y, scaleX * img.subtex.width, scaleY * img.subtex.height),
    C2D_DrawParams._Anonymous_1(scaleX * img.subtex.width / 2.0f, scaleY * img.subtex.height / 2.0f),
    depth,
    angle
  );
  return C2D_DrawImage(img, &params, tint);
}

/** @brief Draws a plain triangle using the GPU
 *  @param[in] x0 X coordinate of the first vertex of the triangle
 *  @param[in] y0 Y coordinate of the first vertex of the triangle
 *  @param[in] clr0 32-bit RGBA color of the first vertex of the triangle
 *  @param[in] x1 X coordinate of the second vertex of the triangle
 *  @param[in] y1 Y coordinate of the second vertex of the triangle
 *  @param[in] clr1 32-bit RGBA color of the second vertex of the triangle
 *  @param[in] x2 X coordinate of the third vertex of the triangle
 *  @param[in] y2 Y coordinate of the third vertex of the triangle
 *  @param[in] clr2 32-bit RGBA color of the third vertex of the triangle
 *  @param[in] depth Depth value to draw the triangle with
 */
bool C2D_DrawTriangle (
    float x0,
    float y0,
    uint clr0,
    float x1,
    float y1,
    uint clr1,
    float x2,
    float y2,
    uint clr2,
    float depth);

/** @brief Draws a plain line using the GPU
 *  @param[in] x0 X coordinate of the first vertex of the line
 *  @param[in] y0 Y coordinate of the first vertex of the line
 *  @param[in] clr0 32-bit RGBA color of the first vertex of the line
 *  @param[in] x1 X coordinate of the second vertex of the line
 *  @param[in] y1 Y coordinate of the second vertex of the line
 *  @param[in] clr1 32-bit RGBA color of the second vertex of the line
 *  @param[in] thickness Thickness, in pixels, of the line
 *  @param[in] depth Depth value to draw the line with
 */
bool C2D_DrawLine (
    float x0,
    float y0,
    uint clr0,
    float x1,
    float y1,
    uint clr1,
    float thickness,
    float depth);

/** @brief Draws a plain rectangle using the GPU
 *  @param[in] x X coordinate of the top-left vertex of the rectangle
 *  @param[in] y Y coordinate of the top-left vertex of the rectangle
 *  @param[in] z Z coordinate (depth value) to draw the rectangle with
 *  @param[in] w Width of the rectangle
 *  @param[in] h Height of the rectangle
 *  @param[in] clr0 32-bit RGBA color of the top-left corner of the rectangle
 *  @param[in] clr1 32-bit RGBA color of the top-right corner of the rectangle
 *  @param[in] clr2 32-bit RGBA color of the bottom-left corner of the rectangle
 *  @param[in] clr3 32-bit RGBA color of the bottom-right corner of the rectangle
 */
bool C2D_DrawRectangle (
    float x,
    float y,
    float z,
    float w,
    float h,
    uint clr0,
    uint clr1,
    uint clr2,
    uint clr3);

/** @brief Draws a plain rectangle using the GPU (with a solid color)
 *  @param[in] x X coordinate of the top-left vertex of the rectangle
 *  @param[in] y Y coordinate of the top-left vertex of the rectangle
 *  @param[in] z Z coordinate (depth value) to draw the rectangle with
 *  @param[in] w Width of the rectangle
 *  @param[in] h Height of the rectangle
 *  @param[in] clr 32-bit RGBA color of the rectangle
 */
extern (D) pragma(inline, true)
bool C2D_DrawRectSolid (float x, float y, float z, float w, float h, uint clr)
{
  return C2D_DrawRectangle(x, y, z, w, h, clr, clr, clr, clr);
}

/** @brief Draws an ellipse using the GPU
 *  @param[in] x X coordinate of the top-left vertex of the ellipse
 *  @param[in] y Y coordinate of the top-left vertex of the ellipse
 *  @param[in] z Z coordinate (depth value) to draw the ellipse with
 *  @param[in] w Width of the ellipse
 *  @param[in] h Height of the ellipse
 *  @param[in] clr0 32-bit RGBA color of the top-left corner of the ellipse
 *  @param[in] clr1 32-bit RGBA color of the top-right corner of the ellipse
 *  @param[in] clr2 32-bit RGBA color of the bottom-left corner of the ellipse
 *  @param[in] clr3 32-bit RGBA color of the bottom-right corner of the ellipse
 *  @note Switching to and from "circle mode" internally requires an expensive state change. As such, the recommended usage of this feature is to draw all non-circular objects first, then draw all circular objects.
*/
bool C2D_DrawEllipse (
    float x,
    float y,
    float z,
    float w,
    float h,
    uint clr0,
    uint clr1,
    uint clr2,
    uint clr3);

/** @brief Draws a ellipse using the GPU (with a solid color)
 *  @param[in] x X coordinate of the top-left vertex of the ellipse
 *  @param[in] y Y coordinate of the top-left vertex of the ellipse
 *  @param[in] z Z coordinate (depth value) to draw the ellipse with
 *  @param[in] w Width of the ellipse
 *  @param[in] h Height of the ellipse
 *  @param[in] clr 32-bit RGBA color of the ellipse
 *  @note Switching to and from "circle mode" internally requires an expensive state change. As such, the recommended usage of this feature is to draw all non-circular objects first, then draw all circular objects.
*/
extern (D) pragma(inline, true)
bool C2D_DrawEllipseSolid (
    float x,
    float y,
    float z,
    float w,
    float h,
    uint clr)
{
  return C2D_DrawEllipse(x, y, z, w, h, clr, clr, clr, clr);
}

/** @brief Draws a circle (an ellipse with identical width and height) using the GPU
 *  @param[in] x X coordinate of the center of the circle
 *  @param[in] y Y coordinate of the center of the circle
 *  @param[in] z Z coordinate (depth value) to draw the ellipse with
 *  @param[in] radius Radius of the circle
 *  @param[in] clr0 32-bit RGBA color of the top-left corner of the ellipse
 *  @param[in] clr1 32-bit RGBA color of the top-right corner of the ellipse
 *  @param[in] clr2 32-bit RGBA color of the bottom-left corner of the ellipse
 *  @param[in] clr3 32-bit RGBA color of the bottom-right corner of the ellipse
 *  @note Switching to and from "circle mode" internally requires an expensive state change. As such, the recommended usage of this feature is to draw all non-circular objects first, then draw all circular objects.
*/
extern (D) pragma(inline, true)
bool C2D_DrawCircle (
    float x,
    float y,
    float z,
    float radius,
    uint clr0,
    uint clr1,
    uint clr2,
    uint clr3)
{
  return C2D_DrawEllipse(x - radius, y - radius, z, radius*2, radius*2, clr0, clr1, clr2, clr3);
}

/** @brief Draws a circle (an ellipse with identical width and height) using the GPU (with a solid color)
 *  @param[in] x X coordinate of the center of the circle
 *  @param[in] y Y coordinate of the center of the circle
 *  @param[in] z Z coordinate (depth value) to draw the ellipse with
 *  @param[in] radius Radius of the circle
 *  @param[in] clr 32-bit RGBA color of the ellipse
 *  @note Switching to and from "circle mode" internally requires an expensive state change. As such, the recommended usage of this feature is to draw all non-circular objects first, then draw all circular objects.
*/
extern (D) pragma(inline, true)
bool C2D_DrawCircleSolid (float x, float y, float z, float radius, uint clr)
{
  return C2D_DrawCircle(x, y, z, radius, clr, clr, clr, clr);
}
/** @} */
