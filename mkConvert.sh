#!/usr/bin/env bash

set -e

for file in *.png *.PNG; do
    [ -e "$file" ] || continue
    out="${file%.*}.jpg"
    magick "$file" -background white -flatten "$out"
done

for file in *.jpeg *.JPEG *.jpg *.JPG; do
    [ -e "$file" ] || continue
    out="${file%.*}.jpg"
    [ "$file" = "$out" ] && continue
    magick "$file" "$out"
done

jpegoptim -q -m85 --strip-all -- *.jpg
