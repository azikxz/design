#!/usr/bin/env bash

file=README.md

# Remove the old README if it exists
rm -f "$file"

# README header
echo "# __PREVIEW OF IMAGES__" >> "$file"
echo "stylix.base16Scheme = inputs.base16.paths.x86_64-linux.themeName;" >> "$file"
echo "" >> "$file"

# Loop through all images
for img in *.{png,jpg,jpeg,gif,webp}; do
  [[ -e "$img" ]] || continue

  # Remove path and extension: compressed/car.jpg → car
  filename="$(basename "${img%.*}")"

  # Add title and preview to README
  echo "## $filename" >> "$file"
  echo "" >> "$file"
  echo "![${filename}](./${img})" >> "$file"
  echo "" >> "$file"
done

echo "README.md created"
