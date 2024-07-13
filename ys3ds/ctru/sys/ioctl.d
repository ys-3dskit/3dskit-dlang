module ys3ds.ctru.sys.ioctl;

extern (C) @nogc nothrow:

enum FIONBIO = 1;

int ioctl (int fd, int request, ...);

