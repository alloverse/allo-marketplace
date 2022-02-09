#!/bin/bash
set -euo pipefail

echo "# Bootstrapping Marketplace."

./allo/assist fetch

pushd apps

for APP in `ls`; do
    echo "# Bootstrapping $APP."
    cd $APP
    ./allo/assist fetch
    cd ..
done

popd
