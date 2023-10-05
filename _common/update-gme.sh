#!/bin/bash

function updateGME()
{
    printf "\n=== Update $2 library... ===\n\n"

    if [ ! -d "../$2" ]; then
        echo "ERROR! Folder $2 is not exists!"
        echo "-- Did you ran the script not from the _common folder? --"
        echo "-- Please change into _common folder and run this script again! --"
        exit 1
    fi

    echo "Removing old $2 folder..."
    rm -Rf "../$2/src/"*.cpp
    rm -Rf "../$2/src/"*.h
    rm -Rf "../$2/src/ext/"*.c
    rm -Rf "../$2/src/ext/"*.h

    git clone --depth 1 "$1" "../$2-tmp"

    echo "Copyng necessary files.."
    cp "../$2-tmp/gme/"*.cpp "../$2/src/"
    cp "../$2-tmp/gme/"*.h "../$2/src/"
    cp "../$2-tmp/gme/ext/"*.c "../$2/src/ext/"
    cp "../$2-tmp/gme/ext/"*.h "../$2/src/ext/"

    echo "Removing unnecessary $2-tmp folder..."
    rm -Rf "../$2-tmp"
}

updateGME https://github.com/libgme/game-music-emu.git libgme
#updateGME https://Wohlstand@bitbucket.org/Wohlstand/game-music-emu.git libgme

printf "\n\nAll libraries has been updated!\n\n"

exit 0
