#!/bin/bash
set -euo pipefail


echo "Usage: Run script with alloplace:// url as argument. Each app will boot after the previous is closed in visor or Ctrl+C. Double Ctrl+C to stop."

pushd apps > /dev/null

for APP in `ls`; do
    cd $APP
    echo "Running $APP"
    sh allo/assist run $1 > /dev/null 2>&1
    cd ..
done


popd > /dev/null