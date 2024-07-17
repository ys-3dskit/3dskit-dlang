module ys3ds.memory;

struct ParametricMallocator(
  /* void* function(size_t) pure @nogc nothrow */ alias mallocF,
  /* void function(void*) pure @nogc nothrow */ alias freeF,
  /* void* function(void*, size_t) pure @nogc nothrow */ alias reallocF
)
{
  import std.experimental.allocator.common : platformAlignment;

  enum uint alignment = platformAlignment;

  // TODO: is linear alloc pure? can i make this pure again? template magic? forward!()?
  static void[] allocate(size_t bytes) @trusted @nogc nothrow /* pure */
  {
    if (!bytes)
      return null;
    auto p = mallocF(bytes);
    return p ? p[0 .. bytes] : null;
  }

  static bool deallocate(void[] b) @system @nogc nothrow /* pure */
  {
    freeF(b.ptr);
    return true;
  }

  static bool reallocate(ref void[] b, size_t s) @system @nogc nothrow /* pure */
  {
    if (!s)
    {
      // fuzzy area in the C standard, see http://goo.gl/ZpWeSE
      // so just deallocate and nullify the pointer
      deallocate(b);
      b = null;
      return true;
    }

    auto p = cast(ubyte*) reallocF(b.ptr, s);
    if (!p)
      return false;
    b = p[0 .. s];
    return true;
  }

  static ParametricMallocator!(mallocF, freeF, reallocF) instance;
}

import core.memory : pureMalloc, pureFree, pureRealloc;

alias Mallocator = ParametricMallocator!(pureMalloc, pureFree, pureRealloc);

import ys3ds.ctru._3ds.allocator.linear : linearAlloc, linearRealloc, linearFree;

alias LinearCtruMallocator = ParametricMallocator!(linearAlloc, linearFree, linearRealloc);

import btl.string : BasicString;

alias String = BasicString!(char, 1, Mallocator);
alias LinearCtruString = BasicString!(char, 1, LinearCtruMallocator);

