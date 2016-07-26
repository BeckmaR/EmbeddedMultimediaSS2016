Install Instruction from Win System
Install Mingw und Msys

2. Add the path of "make", "mingw32-gcc" and the Android gcc to PATH Variable

3. Compile mupdf:
in Folder "thirdparty\mupdf-qt\mupdf"
	1. Windows:
	   make NOX11=yes CC=mingw32-gcc
	2. Android: 
	   make OS=android XCFLAGS="-IC:/Android/android-ndk-r10e/platforms/android-17/arch-arm/usr/include"
	   - Compilation will be aborted, but the right libs were build
	3. Raspberry 3:
           Use the SysGCC toolchain
	   make OS=raspberry XCFLAGS="-IC:/SysGCC/Raspberry/arm-linux-gnueabihf/include"
