#!/bin/bash
set -euo pipefail

./allo/assist upgrade
cd allo/deps/alloui
git checkout main
git pull
git submodule update --init --recursive
cd ../../..

pushd apps

for APP in `ls`; do
    cd $APP
    echo "Bumping alloui and allonet in $APP"
    git checkout -f main
    git pull
    git submodule sync
    git submodule update --init --recursive
    git lfs pull
    ./allo/assist upgrade
    cd allo/deps/alloui
    git checkout main
    git pull
    git submodule update --init --recursive
    cd ../../..
    git add allo/allonet.lock
    git add allo/deps/alloui
    git commit -m "bump allonet and alloui"
    cd ..
    git add $APP
done

popd