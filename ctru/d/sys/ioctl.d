module ctru.d.sys.ioctl;

extern (C):

enum FIONBIO = 1;

int ioctl (int fd, int request, ...);

