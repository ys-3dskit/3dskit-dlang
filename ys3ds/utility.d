module ys3ds.utility;

import btl.autoptr : UniquePtr, RcPtr, first, isRcPtr;
import btl.string : String, isBasicString;
import ys3ds.memory : Mallocator;

@nogc nothrow:

// finally i can make my crime dreams a reality
template transmute(R)
{
  pragma(inline, true)
  R transmute(S)(S src)
  {
    static assert(R.sizeof == S.sizeof, "can only transmute between types of the same size");

    import core.lifetime : move;

    return move(*(cast(R*) &src));
  }
}

// makes a string null terminated
char* nullTerminateInPlace(Str = String)(ref Str s)
if (isBasicString!Str)
{
  s.append('\0');
  return s.ptr;
}

SOut nullTerminatedCopy(SIn = String, SOut = SIn)(auto ref const SIn s)
if (isBasicString!SIn && isBasicString!SOut)
{
  SOut copy;
  copy.resize(s.length + 1);
  copy.ptr[0 .. s.length] = s[];
  copy[s.length] = '\0';

  return copy;
}

Str fromStringzManaged(Str = String)(auto ref const char* s)
if (isBasicString!Str)
{
  // not the most efficient
  size_t length;
  while (s[length] != '\0') length++;

  Str target;
  target.resize(length);
  target.ptr[0 .. length] = s[0 .. length];

  return target;
}

auto toStringzManaged(Str = String, Alloc = Mallocator, bool Unique = true)(auto ref const Str s)
if (isBasicString!Str)
{
  auto slice = s[];
  return toStringzManaged(Alloc, Unique)(slice);
}

auto toStringzManaged(Alloc = Mallocator, bool Unique = true)(auto ref const char[] s)
{
  import core.lifetime : move;

  static if (Unique)
    alias PtrType = UniquePtr;
  else
    alias PtrType = RcPtr;

  auto copy = PtrType!(char[]).make!Alloc(s.length + 1);
  // memcopy into it
  auto tgt = (*copy).ptr;
  tgt[0 .. s.length] = s[];
  tgt[s.length] = 0; // append null terminator

  // char[] -> char -> immutable(char)
  // not modifying the destructor type and stuff should be fine for immutablizing so transmute is okay here
  return transmute!(PtrType!(immutable char))(copy.move.first);
}
