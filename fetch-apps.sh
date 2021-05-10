#!/bin/bash
set -euo pipefail

declare -a APP_REPOS=(
    "https://github.com/alloverse/allo-house"
    "https://github.com/alloverse/allo-clock"
)

HERE=`dirname $0`

pushd $HERE/apps

for REPO in "${APP_REPOS[@]}"; do
    REPONAME=`basename $REPO`
    echo "Cloning $REPO..."
    git clone --recursive $REPO
    cd $REPONAME
    ./allo/assist fetch
    cd ..
done

popd
