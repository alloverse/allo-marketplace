#!/bin/bash
set -euo pipefail

pushd apps

for APP in `ls`; do
    echo "pushing commits in $APP"
    git status
    git push
done
popd