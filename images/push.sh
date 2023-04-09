#!/usr/bin/env bash

set -euo pipefail

for image in short-conn long-conn; do
    docker build -t benesch/"$image" "$image"
    docker push benesch/"$image"
done
