module ys3ds.ctru;

// handwritten equivalent of 3ds.h

public import ys3ds.ctru._3ds.types;
public import ys3ds.ctru._3ds.result;
public import ys3ds.ctru._3ds.ipc;
public import ys3ds.ctru._3ds.svc;
public import ys3ds.ctru._3ds.exheader;
public import ys3ds.ctru._3ds.srv;
public import ys3ds.ctru._3ds.errf;
public import ys3ds.ctru._3ds.os;
public import ys3ds.ctru._3ds.synchronization;
public import ys3ds.ctru._3ds.thread;
public import ys3ds.ctru._3ds.gfx;
public import ys3ds.ctru._3ds.console;
public import ys3ds.ctru._3ds.env;
public import ys3ds.ctru._3ds.util.decompress;
public import ys3ds.ctru._3ds.util.utf;

public import ys3ds.ctru._3ds.allocator.linear;
public import ys3ds.ctru._3ds.allocator.mappable;
public import ys3ds.ctru._3ds.allocator.vram;

public import ys3ds.ctru._3ds.services.ac;
public import ys3ds.ctru._3ds.services.am;
public import ys3ds.ctru._3ds.services.ampxi;
public import ys3ds.ctru._3ds.services.apt;
public import ys3ds.ctru._3ds.services.boss;
public import ys3ds.ctru._3ds.services.cam;
public import ys3ds.ctru._3ds.services.cfgnor;
public import ys3ds.ctru._3ds.services.cfgu;
public import ys3ds.ctru._3ds.services.csnd;
public import ys3ds.ctru._3ds.services.dsp;
public import ys3ds.ctru._3ds.services.fs;
public import ys3ds.ctru._3ds.services.fspxi;
public import ys3ds.ctru._3ds.services.fsreg;
public import ys3ds.ctru._3ds.services.frd;
public import ys3ds.ctru._3ds.services.gspgpu;
public import ys3ds.ctru._3ds.services.gsplcd;
public import ys3ds.ctru._3ds.services.hid;
public import ys3ds.ctru._3ds.services.irrst;
public import ys3ds.ctru._3ds.services.sslc;
public import ys3ds.ctru._3ds.services.httpc;
public import ys3ds.ctru._3ds.services.uds;
public import ys3ds.ctru._3ds.services.ndm;
public import ys3ds.ctru._3ds.services.nim;
public import ys3ds.ctru._3ds.services.nwmext;
public import ys3ds.ctru._3ds.services.ir;
public import ys3ds.ctru._3ds.services.ns;
public import ys3ds.ctru._3ds.services.pmapp;
public import ys3ds.ctru._3ds.services.pmdbg;
public import ys3ds.ctru._3ds.services.ps;
public import ys3ds.ctru._3ds.services.ptmu;
public import ys3ds.ctru._3ds.services.ptmsysm;
public import ys3ds.ctru._3ds.services.ptmgets;
public import ys3ds.ctru._3ds.services.ptmsets;
public import ys3ds.ctru._3ds.services.pxidev;
public import ys3ds.ctru._3ds.services.pxipm;
public import ys3ds.ctru._3ds.services.soc;
public import ys3ds.ctru._3ds.services.mic;
public import ys3ds.ctru._3ds.services.mvd;
public import ys3ds.ctru._3ds.services.nfc;
public import ys3ds.ctru._3ds.services.news;
public import ys3ds.ctru._3ds.services.qtm;
public import ys3ds.ctru._3ds.services.srvpm;
public import ys3ds.ctru._3ds.services.loader;
public import ys3ds.ctru._3ds.services.y2r;
public import ys3ds.ctru._3ds.services.mcuhwc;
public import ys3ds.ctru._3ds.services.cdcchk;

public import ys3ds.ctru._3ds.gpu.gx;
public import ys3ds.ctru._3ds.gpu.gpu;
public import ys3ds.ctru._3ds.gpu.shbin;
public import ys3ds.ctru._3ds.gpu.shaderProgram;

public import ys3ds.ctru._3ds.ndsp.ndsp;
public import ys3ds.ctru._3ds.ndsp.channel;

public import ys3ds.ctru._3ds.applets.swkbd;
public import ys3ds.ctru._3ds.applets.error;

public import ys3ds.ctru._3ds.applets.miiselector;

public import ys3ds.ctru._3ds.archive;
public import ys3ds.ctru._3ds.romfs;
public import ys3ds.ctru._3ds.font;
public import ys3ds.ctru._3ds.mii;

public import ys3ds.ctru._3ds.gdbhio_dev;
public import ys3ds.ctru._3ds._3dslink;
