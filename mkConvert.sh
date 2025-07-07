#!/usr/bin/env bash

# Convert PNG → JPG and remove PNG
for img in *.png; do
  [[ -e "$img" ]] || continue
  base="${img%.png}"
  magick "$img" "${base}.jpg" && rm "$img"
done

# Rename JPEG → JPG
for img in *.jpeg; do
  [[ -e "$img" ]] || continue
  base="${img%.jpeg}"
  mv -- "$img" "${base}.jpg"
done

# Optimize all JPG files with 85% quality
jpegoptim -q -m85 --strip-all -- *.jpg

# Rename optimized JPGs to include a ' before extension
for img in *.jpg; do
  [[ -e "$img" ]] || continue
  base="${img%.jpg}"
  [[ "$base" == *"'" ]] && continue
  mv -- "$img" "${base}'".jpg
done
