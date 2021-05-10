#!/bin/bash
set -euo pipefail

declare -a APP_REPOS=(
    "https://github.com/alloverse/allo-house"
    "https://github.com/alloverse/allo-clock"
    "https://github.com/alloverse/allo-jukebox"
    "https://github.com/alloverse/allo-whiteboard"
    "https://github.com/alloverse/allo-fileviewer"
)

HERE=`dirname $0`

pushd $HERE/apps

for REPO in "${APP_REPOS[@]}"; do
    REPONAME=`basename $REPO`
    if [ ! -d "$REPONAME" ]; then
        echo "Cloning $REPO..."
        git clone --recursive $REPO
        cd $REPONAME
        ./allo/assist fetch
        cd ..
    fi
done

popd
