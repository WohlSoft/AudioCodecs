# AudioCodecs collection

A collection of various audio codecs and their dependencies.

This is a set of dependencies required for SDL Mixer X audio library, except of SDL2 which is updating offten.

This set of libraries is designed to be buildable through QMake and CMake building systems.

Note: to build libtimidity, you need have latest libSDL2 be installed! (this library was modified to support files through SDL_RWops() API)

# CI Badges

| Operating system | Badge |
|-------------|--------------------|
| **Linux:** | [![Build Status](https://semaphoreci.com/api/v1/wohlstand/audiocodecs/branches/master/shields_badge.svg)](https://semaphoreci.com/wohlstand/audiocodecs) |
| **Windows:** | [![Build status](https://ci.appveyor.com/api/projects/status/fjmpe4luqbll8x6l?svg=true)](https://ci.appveyor.com/project/Wohlstand/audiocodecs) |
| **macOS** | [![Build Status](https://travis-ci.org/WohlSoft/AudioCodecs.svg?branch=master)](https://travis-ci.org/WohlSoft/AudioCodecs) |

# How to build

## Linux
You will need:
* CMake >= 3.2
* GCC and G++ >= 4.8
* libSDL2 library package installed, OR you can use -DUSE_LOCAL_SDL2=ON to use the vendored copy of SDL2 instead, or use the -DDOWNLOAD_SDL2_DEPENDENCY=ON CMake flag to automatically download from [official GitHub repository](https://github.com/libsdl-org/SDL) and build this.

**System install** _(will be installed with /usr/local/ prefix)_
```bash
# Step 1: Download repository
git clone https://github.com/WohlSoft/AudioCodecs.git
cd AudioCodecs

# Step 2: PRepare build directory
mkdir build
cd build

# Step 3: Configure project ()
cmake ..

# Step 4: Build
make
# Hint: to speed-up build use -j <num jobs> flag. Count of jobs should be equal number of CPU cores

# Step 5: Install
sudo make install
```

**Custom install** _(You can install result into any folder and you don't need to have root to install)_
```bash
# Step 1: Download repository
git clone https://github.com/WohlSoft/AudioCodecs.git
cd AudioCodecs

# Step 2: PRepare build directory
mkdir build
cd build

# Step 3: Configure project ()
cmake -DDOWNLOAD_SDL2_DEPENDENCY=ON -DCMAKE_INSTALL_PREFIX=~/AudioCodecs/ ..

# Step 4: Build and install
cmake -build . -config release -target install -- -j 2
#   Tip: instead of "release" you can have "debug" to build debug versions. Instead of "2" put your actual count of CPU cores
```

## macOS
The build for macOS is very similar to Linux way, you just can follow Linux way to build libraries

## Windows
You will need:
* CMake >= 3.2
* MinGW >= 4.8, MinGW-w64 >= 5, or MSVC >=2015 (on your taste)

**Build with MinGW**
```winbatch
rem Step 1: Download repository
git clone https://github.com/WohlSoft/AudioCodecs.git
cd AudioCodecs

rem Step 2: PRepare build directory
mkdir build
cd build

rem Step 3: Configure project
cmake -G "MinGW Makefiles" -DDOWNLOAD_SDL2_DEPENDENCY=ON -DCMAKE_INSTALL_PREFIX=%UserProfile%\MyLibs\ ..

rem Step 4: Build and install
cmake -build . -config release -target install -- -j 2
rem Tip: instead of "release" you can have "debug" to build debug versions. Instead of "2" put your actual count of CPU cores
```

**Build with MinGW-w64** (A way to get 64-bit Windows assemblies)
```winbatch
rem Step 1: Download repository
git clone https://github.com/WohlSoft/AudioCodecs.git
cd AudioCodecs

rem Step 2: PRepare build directory
mkdir build
cd build
rem Important: You must to set the MinGW-w64 path first, also you must to remove a git from PATH if it is set
rem Full path may be different in dependence of version. Please fix this to match with your
set PATH=C:\mingw-w64\x86_64-6.3.0-posix-seh-rt_v5-rev1\mingw64\bin;%PATH:C:\Program Files\Git\usr\bin;=%

rem Step 3: Configure project
cmake -G "MinGW Makefiles" -DDOWNLOAD_SDL2_DEPENDENCY=ON -DCMAKE_INSTALL_PREFIX=%UserProfile%\MyLibs\ ..

rem Step 4: Build and install
cmake -build . -config release -target install -- -j 2
rem Tip: instead of "release" you can have "debug" to build debug versions. Instead of "2" put your actual count of CPU cores
```

**Build with MSVC**
```winbatch
rem Step 1: Download repository
git clone https://github.com/WohlSoft/AudioCodecs.git
cd AudioCodecs

rem Step 2: PRepare build directory
mkdir build
cd build

rem Step 3: Configure project
cmake -G "Visual Studio 14 2015" -DDOWNLOAD_SDL2_DEPENDENCY=ON -DCMAKE_INSTALL_PREFIX=%UserProfile%\MyLibs\ ..
rem HINT: If you want to have 64-bit build, use "Visual Studio 14 2015 Win64" generator
rem HINT: You can take full list of available generators by requesting of "cmake --help"

rem Step 4: Build and install
cmake -build . -config release -target install -- -j 2
rem Tip: instead of "release" you can have "debug" to build debug versions. Instead of "2" put your actual count of CPU cores
```


# Licenses
* **libADLMIDI:** GNU LGPLv3+ or GNU GPLv3+
* **libFLAC:** Multiple: BSD 3-clause "New" or "Revised" License (libFLAC, libFLAC++), GNU GPL (extra plugins and tools)
* **libFluidLite:** GNU LGPLv2.1+
* **libGME:** GNU LGPLv2.1+
* **libModPlug:** Public Domain
* **libOGG:** BSD 3-clause "New" or "Revised" License
* **libOpenMPT:** BSD
* **libOPNMIDI:** GNU LGPLv3+ or GNU GPLv3+
* **libOpus:** BSD 3-clause "New" or "Revised" License
* **libSDL2:** ZLib
* **libTimidity-SDL:** The "Artistic License"
* **libVorbis:** BSD 3-clause "New" or "Revised" License
* **libWavPack:** BSD 3-clause "New" or "Revised" License
* **libXMP:** GNU LGPLv2+, partially MIT
* **libZlib:** ZLib license
* **libEDMIDI:** ZLib license

# Libraries are can be freely used in non-free projects:

## Static linking
(BSD, ZLib, and "Artistic" licenses are allows usage in closed-source projects)
* libFLAC
* libModPlug
* libOGG
* libOpenMPT
* libOpus
* libSDL2
* libTimidity-SDL
* libVorbis
* libWavPack
* libZlib
* libEDMIDI

## Dynamic linking
(LGPL allows usage in closed-source projects when LGPL-licensed components are linked dynamically)
* libFLAC
* libFluidLite
* libGME
* libModPlug
* libOGG
* libOpenMPT
* libOpus
* libSDL2
* libTimidity
* libVorbis
* libWavPack
* libXMP
* libZlib
* libEDMIDI
