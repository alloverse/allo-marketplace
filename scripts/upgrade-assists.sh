#!/bin/bash
set -euo pipefail

echo "Usage: update assist in marketplace, then run this script."
echo "This script will bump copy assist, and bump alloui and allonet in all the apps,"
echo "and make a commit."
echo "IT WILL NOT PUSH THEM. Use the push-apps.sh script to push after verifying that"
echo "all the apps work after bumping."

pushd apps > /dev/null

for APP in `ls`; do
    cd $APP
    if [ -n "$(git status --porcelain)" ]; then 
        echo "Working copy for $APP is dirty, refusing to run."
        cd ..
        popd > /dev/null
        exit 1
    fi
    cd ..
done

popd > /dev/null

./allo/assist upgrade
cd allo/deps/alloui
git checkout main
git pull
git submodule update --init --recursive
cd ../../..

pushd apps > /dev/null

for APP in `ls`; do
    echo "Bumping assist, alloui and allonet in $APP"
    cd $APP
    git checkout -f main
    git pull
    git submodule sync
    git submodule update --init --recursive
    git lfs pull
    cp ../../allo/assist allo/
    cp ../../allo/assist.lua allo/
    cp ../../allo/boot.lua allo/
    ./allo/assist upgrade
    cd allo/deps/alloui
    git checkout main
    git pull
    git submodule update --init --recursive
    cd ../../..
    git add allo/allonet.lock
    git add allo/deps/alloui
    git add allo
    git commit -m "bump allonet, alloui and assist" || true
    cd ..
    git add $APP
done

popd > /dev/null
