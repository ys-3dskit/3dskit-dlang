/**
 * @file gdbhio.h
 * @brief Luma3DS GDB HIO (called File I/O in GDB documentation) functions.
 */

//import core.sys.posix.fcntl;
//import core.sys.posix.signal;

extern (C):

// missing types, referenced against devkitarm headers
alias off_t = long;
alias time_t = long;
alias suseconds_t = long;
alias mode_t = uint;

struct timeval
{
  time_t tv_sec;
  suseconds_t tv_usec;
}

struct timespec {
  time_t tv_sec;
  long tv_nsec;
}

struct stat_
{
  short /* dev_t */ st_dev;
  ushort /* ino_t */ st_ino;
  mode_t st_mode;
  ushort /* nlink_t */ st_nlink;
  ushort /* uid_t */ st_uid;
  ushort /* gid_t */ st_gid;
  short /* dev_t */ st_rdev;
  long /* off_t */ st_size;

  timespec st_atim;
  timespec st_mtime;
  timespec st_ctime;
  long /* blksize_t */ st_blksize;
  long /* blkcnt_t */ st_blocks;

  long[2] st_spare4;
}

// end of missing types

enum GDBHIO_STDIN_FILENO = 0;
enum GDBHIO_STDOUT_FILENO = 1;
enum GDBHIO_STDERR_FILENO = 2;

int gdbHioOpen (const(char)* pathname, int flags, mode_t mode);
int gdbHioClose (int fd);
int gdbHioRead (int fd, void* buf, uint count);
int gdbHioWrite (int fd, const(void)* buf, uint count);
off_t gdbHioLseek (int fd, off_t offset, int flag);
int gdbHioRename (const(char)* oldpath, const(char)* newpath);
int gdbHioUnlink (const(char)* pathname);
int gdbHioStat (const(char)* pathname, stat_* st);
int gdbHioFstat (int fd, stat_* st);
int gdbHioGettimeofday (timeval* tv, void* tz);
int gdbHioIsatty (int fd);

///< Host I/O 'system' function, requires 'set remote system-call-allowed 1'.
int gdbHioSystem (const(char)* command);
