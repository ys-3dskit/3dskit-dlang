module ys3ds.utility;

// useful helpers for 3DS development in D

T* dalloc(T)()
{
  import core.memory : pureMalloc;

  auto ptr = cast(T*) pureMalloc(T.sizeof);
  *ptr = T.init;
  return ptr;
}

T[] dalloc_slice(T)(size_t len)
{
  import core.memory : pureMalloc;

  auto ptr = cast(T*) pureMalloc(T.sizeof * len);
  auto slice = ptr[0 .. len];
  slice[] = T.init;
  return slice;
}

void dfree(T)(T* ptr)
{
  import core.memory : pureFree;
  pureFree(cast(void*) ptr);
}

void dfree(T)(T[] slice)
{
  import core.memory : pureFree;
  pureFree(cast(void*) slice.ptr);
}

// finally i can make my crime dreams a reality
template transmute(R)
{
  pragma(inline, true)
  R transmute(S)(S src)
  {
    static assert(R.sizeof == S.sizeof, "can only transmute between types of the same size");

    return *(cast(R*) &src);
  }
}

T[] slicedup(T)(const T[] src, bool freeSrc = false)
{
  auto dst = dalloc_slice!T(src.length);
  dst[] = src[];
  if (free) dfree(src);
  return dst;
}

/* // designed specifically for automem's String
immutable(char)* toStringz(T)(scope const T s)
{
  static if (hasMember!(T, "opSlice")) // Vector
    return toStringz(s[]);
  else
    return toStringz((*s)[]); // Expecting an RC!Vector or Unique!Vector
} */

// phobos std.string.toStringz
immutable(char)* toStringz(scope const(char)[] s, bool freeInput = false)
{
	if (s.length == 0) // empty
		return "".ptr;

	// make copy
	auto copy = dalloc_slice!char(s.length + 1);
	copy[0 .. s.length] = s[];
	copy[s.length] = 0; // write null terminator

	if (freeInput) dfree(s);

	return &(cast(immutable) copy[0]);
}

immutable(char)[] fromStringz(const char* s, bool freeInput = false)
{
  // not the most efficient fromStringz in the world. sorry bout that.

  size_t length;
  while (s[length] != '\0') length++;

  auto copy = dalloc_slice!char(length);
  copy[] = s[0 .. length];

  if (freeInput) dfree(s);

  // make it immutable to satisfy the string gods
  return transmute!(immutable(char)[])(copy);
}
