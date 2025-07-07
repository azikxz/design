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

  # Remove path and extension and trailing apostrophe: name'.jpg → name
  base_name="$(basename "${img%.*}")"
  clean_name="${base_name%"'"}"

  # Add title and preview to README
  echo "## $clean_name" >> "$file"
  echo "" >> "$file"
  echo "![${clean_name}](./${img})" >> "$file"
  echo "" >> "$file"
done

echo "README.md created"
