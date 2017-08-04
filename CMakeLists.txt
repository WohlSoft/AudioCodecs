cmake_minimum_required (VERSION 2.8.11)
project (AudioCodecs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# --- TODO: implement building or usage of pre-built libSDL here ---
# set(SNDIO OFF) # Disable sndio that is not needed to us
# add_subdirectory(libSDL2)

add_subdirectory(libogg)
add_subdirectory(libvorbis)
add_subdirectory(libFLAC)
add_subdirectory(libid3tag)
add_subdirectory(libmad)
add_subdirectory(zlib)
add_subdirectory(libgme)
add_subdirectory(libtimidity)
add_subdirectory(libmodplug)
add_subdirectory(libADLMIDI)
add_subdirectory(libOPNMIDI)

