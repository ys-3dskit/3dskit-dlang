module ys3ds.ctru;

// handwritten equivalent of 3ds.h

import ys3ds.ctru._3ds.types;
import ys3ds.ctru._3ds.result;
import ys3ds.ctru._3ds.ipc;
import ys3ds.ctru._3ds.svc;
import ys3ds.ctru._3ds.exheader;
import ys3ds.ctru._3ds.srv;
import ys3ds.ctru._3ds.errf;
import ys3ds.ctru._3ds.os;
import ys3ds.ctru._3ds.synchronization;
import ys3ds.ctru._3ds.thread;
import ys3ds.ctru._3ds.gfx;
import ys3ds.ctru._3ds.console;
import ys3ds.ctru._3ds.env;
import ys3ds.ctru._3ds.util.decompress;
import ys3ds.ctru._3ds.util.utf;

import ys3ds.ctru._3ds.allocator.linear;
import ys3ds.ctru._3ds.allocator.mappable;
import ys3ds.ctru._3ds.allocator.vram;

import ys3ds.ctru._3ds.services.ac;
import ys3ds.ctru._3ds.services.am;
import ys3ds.ctru._3ds.services.ampxi;
import ys3ds.ctru._3ds.services.apt;
import ys3ds.ctru._3ds.services.boss;
import ys3ds.ctru._3ds.services.cam;
import ys3ds.ctru._3ds.services.cfgnor;
import ys3ds.ctru._3ds.services.cfgu;
import ys3ds.ctru._3ds.services.csnd;
import ys3ds.ctru._3ds.services.dsp;
import ys3ds.ctru._3ds.services.fs;
import ys3ds.ctru._3ds.services.fspxi;
import ys3ds.ctru._3ds.services.fsreg;
import ys3ds.ctru._3ds.services.frd;
import ys3ds.ctru._3ds.services.gspgpu;
import ys3ds.ctru._3ds.services.gsplcd;
import ys3ds.ctru._3ds.services.hid;
import ys3ds.ctru._3ds.services.irrst;
import ys3ds.ctru._3ds.services.sslc;
import ys3ds.ctru._3ds.services.httpc;
import ys3ds.ctru._3ds.services.uds;
import ys3ds.ctru._3ds.services.ndm;
import ys3ds.ctru._3ds.services.nim;
import ys3ds.ctru._3ds.services.nwmext;
import ys3ds.ctru._3ds.services.ir;
import ys3ds.ctru._3ds.services.ns;
import ys3ds.ctru._3ds.services.pmapp;
import ys3ds.ctru._3ds.services.pmdbg;
import ys3ds.ctru._3ds.services.ps;
import ys3ds.ctru._3ds.services.ptmu;
import ys3ds.ctru._3ds.services.ptmsysm;
import ys3ds.ctru._3ds.services.ptmgets;
import ys3ds.ctru._3ds.services.ptmsets;
import ys3ds.ctru._3ds.services.pxidev;
import ys3ds.ctru._3ds.services.pxipm;
import ys3ds.ctru._3ds.services.soc;
import ys3ds.ctru._3ds.services.mic;
import ys3ds.ctru._3ds.services.mvd;
import ys3ds.ctru._3ds.services.nfc;
import ys3ds.ctru._3ds.services.news;
import ys3ds.ctru._3ds.services.qtm;
import ys3ds.ctru._3ds.services.srvpm;
import ys3ds.ctru._3ds.services.loader;
import ys3ds.ctru._3ds.services.y2r;
import ys3ds.ctru._3ds.services.mcuhwc;
import ys3ds.ctru._3ds.services.cdcchk;

import ys3ds.ctru._3ds.gpu.gx;
import ys3ds.ctru._3ds.gpu.gpu;
import ys3ds.ctru._3ds.gpu.shbin;
import ys3ds.ctru._3ds.gpu.shaderProgram;

import ys3ds.ctru._3ds.ndsp.ndsp;
import ys3ds.ctru._3ds.ndsp.channel;

import ys3ds.ctru._3ds.applets.swkbd;
import ys3ds.ctru._3ds.applets.error;

import ys3ds.ctru._3ds.applets.miiselector;

import ys3ds.ctru._3ds.archive;
import ys3ds.ctru._3ds.romfs;
import ys3ds.ctru._3ds.font;
import ys3ds.ctru._3ds.mii;

import ys3ds.ctru._3ds.gdbhio_dev;
import ys3ds.ctru._3ds._3dslink;
