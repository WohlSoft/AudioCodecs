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

updateRepo https://github.com/Wohlstand/libADLMIDI.git libADLMIDI
updateRepo https://github.com/Wohlstand/libOPNMIDI.git libOPNMIDI

printf "\n\nAll libraries has been updated!\n\n"

exit 0

