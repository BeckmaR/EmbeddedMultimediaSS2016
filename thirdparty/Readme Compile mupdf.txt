1. Install Mingw und Msys

2. Add the path of "make", "mingw32-gcc" and the Android gcc to PATH VARIABLE

3. Compile mupdf:
in Folder "thirdparty\mupdf-qt\mupdf"
	1. Windows:
	   make build=release NOX11=yes CC=mingw32-gcc
	2. Android: 
	   make build=release OS=android XCFLAGS="-IC:/Android/android-ndk-r10e/platforms/android-17/arch-arm/usr/include"
	   - Compilation will be aborted, but the right libs were build

4. build the "lib_mupdf" Projekt in the "src" folder