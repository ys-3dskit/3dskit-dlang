module core.sys.horizon.sys.lock;

extern (C) @nogc:

alias lock_t = int;

// _LOCK_RECURSIVE_T
struct flock_t
{
  lock_t lock;
  uint thread_tag;
  uint counter;
}
