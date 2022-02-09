#!/bin/bash
set -euo pipefail

echo "This script will bump alloui and allonet in all the apps, and make a commit."
echo "IT WILL NOT PUSH THEM. Use the push-apps.sh script to push after verifying that"
echo "all the apps work after bumping."
echo
echo

echo "Upgrading assist and alloui in marketplace itself"
./allo/assist upgrade
cd allo/deps/alloui
git checkout main
git pull
git submodule update --init --recursive
cd ../../..

pushd apps > /dev/null

for APP in `ls`; do
    cd $APP
    if [ -n "$(git status --porcelain)" ]; then 
        echo
        echo "!! Working copy for $APP is dirty, refusing to run."
        cd ..
        popd > /dev/null
        exit 1
    fi
    cd ..
done

for APP in `ls`; do
    cd $APP
    echo 
    echo "#########################################"
    echo "## Bumping alloui and allonet in $APP  ##"
    echo "#########################################"
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
    git commit -m "bump allonet and alloui" || true
    cd ..
    git add $APP
done

popd > /dev/null

echo ""
echo ""
echo "!! Done! Now, test all the apps locally, then run push-apps,"
echo "   and then commit and push here in marketplace."