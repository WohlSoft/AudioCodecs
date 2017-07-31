# AudioCodecs collection

A collection of various audio codecs and their dependencies.

This is a set of dependencies required for SDL Mixer X audio library, except of SDL2 which is updating offten.

This set of libraries is designed to be buildable through QMake building system.

Note: to build libid3tag and libtimidity, you need have latest libSDL2 be installed! (those libraries are modified to support files through SDL_RWops() API)


# Licenses
* **libADLMIDI:** GNU LGPLv3+ or GNU GPLv3+
* **libFLAC:** Multiple: BSD 3-clause "New" or "Revised" License (libFLAC, libFLAC++), GNU GPL (extra plugins and tools)
* **libFluidLite:** GNU LGPLv2.1+
* **libGME:** GNU LGPLv2.1+
* **libID3Tag:** GNU GPLv2+ (a.k.a. v2 or any later version)
* **libMAD:** GNU GPLv2+ (a.k.a. v2 or any later version)
* **libMikMod:** GNU LGPLv2+
* **libModPlug:** Public Domain
* **libOGG:** BSD 3-clause "New" or "Revised" License
* **libOPNMIDI:** GNU LGPLv3+ or GNU GPLv3+
* **libTimidity:** The "Artistic License"
* **libVorbis:** BSD 3-clause "New" or "Revised" License
* **libZlib:** ZLib license

# Libraries are can be freely used in commercial projects:

## Static linking
(BSD, ZLib, and "Artistic" licenses are allows usage in closed-source projects)
* libFLAC
* libModPlug
* libOGG
* libTimidity
* libVorbis
* libZlib

## Dynamic linking
(LGPL allows usage in closed-source projects when LGPL-licensed components are linked dynamically)
* libFLAC
* libFluidLite
* libGME
* libMikMod
* libModPlug
* libOGG
* libTimidity
* libVorbis
* libZlib
