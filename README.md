patchBin
========

Easily Patch Binary Files

Usage:
 
patchBin [byte size] [offset] [hex to be written] [file]
 
patchBin -h : Displays Help
patchBin -v : Displays Version
patchBin -c : Displays Credits
 
Supported Byte Sizes:
 
2 Byte
4 Byte 
8 Byte
 
Example:

TheiPad:/var/mobile/ root# patchBin 4 0x123456 0x1eff2fe1 /var/mobile/binary
[+] Opening File for writing
[+] Found Position for writing
[+] Patching File
[+] Closing File
