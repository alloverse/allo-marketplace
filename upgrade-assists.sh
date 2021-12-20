#!/bin/bash
set -euo pipefail

# Usage: update assist in jukebox, then run this script

cp apps/allo-jukebox/allo/assist allo/
cp apps/allo-jukebox/allo/assist.lua allo/
cp apps/allo-jukebox/allo/boot.lua allo/

./allo/assist upgrade
cd allo/deps/alloui
git checkout main
git pull
git submodule update --init --recursive
cd ../../..

pushd apps

for APP in `ls`; do
    cd $APP
    echo "Bumping assist, alloui and allonet in $APP"
    git checkout -f main
    git pull
    git submodule sync
    git submodule update --init --recursive
    git lfs pull
    cp ../allo-jukebox/allo/assist allo/
    cp ../allo-jukebox/allo/assist.lua allo/
    cp ../allo-jukebox/allo/boot.lua allo/
    ./allo/assist upgrade
    cd allo/deps/alloui
    git checkout main
    git pull
    git submodule update --init --recursive
    cd ../../..
    git add allo/allonet.lock
    git add allo/deps/alloui
    git add allo
    git commit -m "bump allonet, alloui and assist"
    cd ..
    git add $APP
done

popd
