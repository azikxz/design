<div align="center">
	<h1>【 DESIGN 】</h1>
</div>

# base16 themes selfmade/stolen etc.

- [stylix](https://github.com/danth/stylix)
- [base16.nix](https://github.com/SenchoPens/base16.nix)
- [flavours](https://github.com/Misterio77/flavours)
- [previewer](https://sesh.github.io/base16-viewer/) use without comments as (# something)

## Cheatsheet

```yaml
system: "base16"
name: "themeName"
author: "yourName"
variant: "dark" # dark/light

base00: "16292c" # Default Background (background)
base01: "3d4a50" # Lighter Background (status bars, line number)
base02: "646b73" # Selection Background
base03: "8c8d96" # Comments, Invisibles, Line Highlighting
base04: "b3aeb9" # Dark Foreground (status bars)
base05: "dacfdd" # Default Foreground, Caret, Delimiters, Operators
base06: "dfd6e2" # Light Foreground (Not often used)
base07: "e5dde7" # Light Background (Not often used)
base08: "a6609d" # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
base09: "75797a" # Integers, Boolean, Constants, XML Attributes, Markup Link Url
base0A: "627d84" # Classes, Markup Bold, Search Text Background
base0B: "9e8056" # Strings, Inherited Class, Markup Code, Diff Inserted
base0C: "537f89" # Support, Regular Expressions, Escape Characters, Markup Quotes
base0D: "4e817e" # Functions, Methods, Attribute IDs, Headings
base0E: "578b8e" # Keywords, Storage, Selector, Markup Italic, Diff Changed
base0F: "827e9c" # Deprecated, Opening/Closing Embedded Language Tags
```

## nixOS

```nix
{
 inputs = {
  ...
  stylix.url = "github:danth/stylix"; # stylix
  design = {
   url = "sourcehut:~neverness/design";
   # optional
   inputs = {
    nixpkgs.follows = "nixpkgs";
    flake-utils.follows = "flake-utils";
   };
  }; # designing repo
  ...
 };

 outputs = inputs: {
  ...
  nixosConfigurations.nixos = lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules =
   let
    themeName = "horizon-dark";
   in
   [
    {
     stylix.base16Scheme = # ~./base16/*.yaml
      inputs.design.paths.x86_64-linux."${themeName}";
    }
   ];
  };
  ...
 };
}
```
