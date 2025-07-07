{
  description = "Flake с индивидуальным доступом к обоям";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };

      wallpaperDir = ./.;
      exts = [ ".jpg" ];

      wallpaperPaths = lib.mapAttrs (name: drv: "${drv}/${name}.jpg") (
        lib.listToAttrs (
          map
            (
              file:
              let
                name = lib.removeSuffix (lib.findFirst (ext: lib.hasSuffix ext file) ".jpg" exts) file;
                path = wallpaperDir + "/${file}";
              in
              {
                inherit name;
                value = pkgs.runCommand name { src = path; } ''
                  mkdir -p $out
                  cp "$src" "$out/${file}"
                '';
              }
            )
            (
              lib.filter (f: lib.any (ext: lib.hasSuffix ext f) exts) (
                lib.attrNames (builtins.readDir wallpaperDir)
              )
            )
        )
      );
    in
    wallpaperPaths
    // {
      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          shellHook = ''exec fish'';
          packages =
            with pkgs;
            let
              mk = name: path: (writeScriptBin name (builtins.readFile path));
            in
            [
              (mk "whdl" ./wallHavenDL.sh)

              (mk "mkConvert" ./mkConvert.sh)
              jpegoptim

              (mk "mkReadme" ./mkReadme.sh)
            ];
        };
      };
    };
}
