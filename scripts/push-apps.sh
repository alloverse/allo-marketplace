#!/bin/bash
set -euo pipefail

pushd apps

for APP in `ls`; do
    if [ "$APP" == "allo-cloud-generator" ]; then
        continue
    fi
    echo 
    echo "# Pushing commits in $APP"
    cd $APP
    git status
    git push
    cd ..
done
popd