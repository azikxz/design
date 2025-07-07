{
  description = "Base16 color schemes flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };

      schemeDir = ./.;

      base16Paths = lib.mapAttrs (_: drv: "${drv}/scheme.yaml") (
        lib.listToAttrs (
          map (
            file:
            let
              name = lib.removeSuffix ".yaml" file;
              path = schemeDir + "/${file}";
            in
            {
              inherit name;
              value = pkgs.runCommand name { } ''
                mkdir -p $out
                cp ${path} $out/scheme.yaml
              '';
            }
          ) (lib.filter (f: lib.hasSuffix ".yaml" f) (lib.attrNames (builtins.readDir schemeDir)))
        )
      );
    in
    base16Paths;
}
