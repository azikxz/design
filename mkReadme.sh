#!/usr/bin/env bash

file=README.md

# Remove the old README if it exists
rm -f "$file"

# README header
echo '<div align="center">
  <h1>【 __PREVIEW OF IMAGES__ 】</h1>
</div>' >> "$file"

echo '
```nix
  # -- flake.nix
  { inputs.wallpapers.url =
    "sourcehut:~neverness/design/wallpapers"; }
  # -- other .nix file
  { stylix.image = inputs.wallpapers.wallName; }
```' >> "$file"

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
