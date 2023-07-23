#!/bin/bash

function updateRepo()
{
    printf "\n=== Update $2 library... ===\n\n"

    if [ ! -d "../$2" ]; then
        echo "ERROR! Folder $2 is not exists!"
        echo "-- Did you ran the script not from the _common folder? --"
        echo "-- Please change into _common folder and run this script again! --"
        exit 1
    fi
    echo "Removing old $2 folder..."
    rm -Rf "../$2"

    git clone --depth 1 "$1" "../$2"

    echo "Removing unnecessary $2/.git folder..."
    rm -Rf "../$2/.git"
}

function updateXMP()
{
    printf "\n=== Update $2 library... ===\n\n"

    if [ ! -d "../$2" ]; then
        echo "ERROR! Folder $2 is not exists!"
        echo "-- Did you ran the script not from the _common folder? --"
        echo "-- Please change into _common folder and run this script again! --"
        exit 1
    fi

    echo "Removing old $2 folder..."
    rm -Rf "../$2/src/"
    rm -Rf "../$2/cmake/"
    rm -Rf "../$2/docs/"

    git clone --depth 1 "$1" "../$2-tmp"

    echo "Copyng necessary files.."
    cp -a "../$2-tmp/src" "../$2/src"
    cp -a "../$2-tmp/cmake" "../$2/cmake"
    cp -a "../$2-tmp/docs" "../$2/docs"
    cp "../$2-tmp/CMakeLists.txt" "../$2/CMakeLists.txt"
    cp "../$2-tmp/include/xmp.h" "../$2/include/xmp.h"
    cp "../$2-tmp/libxmp.pc.in" "../$2/libxmp.pc.in"
    cp "../$2-tmp/libxmp.map" "../$2/libxmp.map"
    cp "../$2-tmp/libxmp-config.cmake" "../$2/libxmp-config.cmake"

    echo "Removing unnecessary $2-tmp folder..."
    rm -Rf "../$2-tmp"
}

updateRepo https://github.com/Wohlstand/libADLMIDI.git libADLMIDI
updateRepo https://github.com/Wohlstand/libOPNMIDI.git libOPNMIDI
updateRepo https://github.com/Wohlstand/libEDMIDI.git libEDMIDI
updateXMP https://github.com/libxmp/libxmp.git libxmp


printf "\n\nAll libraries has been updated!\n\n"

exit 0
