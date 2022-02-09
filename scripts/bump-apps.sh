#!/bin/bash
set -euo pipefail

pushd apps

for APP in `ls`; do
    cd $APP
    git checkout -f main
    git pull
    git submodule sync
    git submodule update --init --recursive
    git lfs pull
    ./allo/assist fetch
    cd ..
    git add $APP
done

popd