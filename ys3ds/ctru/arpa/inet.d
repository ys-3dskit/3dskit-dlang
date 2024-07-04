module ys3ds.ctru.arpa.inet;

import ys3ds.ctru.sys.socket;

import std.bitmanip : swapEndian;

extern (C):

uint htonl (uint hostlong)
{
  return swapEndian(hostlong);
}

ushort htons (ushort hostshort)
{
  return swapEndian(hostshort);
}

uint ntohl (uint netlong)
{
  return swapEndian(netlong);
}

ushort ntohs (ushort netshort)
{
  return swapEndian(netshort);
}

in_addr_t inet_addr (const(char)* cp);
int inet_aton (const(char)* cp, in_addr* inp);
char* inet_ntoa (in_addr in_);

const(char)* inet_ntop (int af, const(void)* src, char* dst, socklen_t size);
int inet_pton (int af, const(char)* src, void* dst);

