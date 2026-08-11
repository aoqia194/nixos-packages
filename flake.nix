{
    description = "aoqia's nixos packages";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
    };

    outputs = inputs: let
        packageNames = [
            "mac-tahoe-icons"
            "mac-tahoe-cursors"
        ];
        overlay = final: prev: builtins.listToAttrs (map (name: {
            inherit name;
            value = final.callPackage (./packages + "/${name}") {};
        }) packageNames);

        systems = [ "x86_64-linux" "aarch64-linux" ];
        forEachSystem = f: inputs.nixpkgs.lib.genAttrs systems f;
        pkgsFor = system: import inputs.nixpkgs {
            inherit system;
            overlays = [ overlay ];
            config.allowUnfree = true;
        };
    in {
        overlays.default = overlay;

        packages = forEachSystem (system: let
            pkgs = pkgsFor system;
            localPackages = inputs.nixpkgs.lib.genAttrs packageNames (name: pkgs.${name});
        in localPackages // {
            default = pkgs.${builtins.head packageNames};
        });

        devShells = forEachSystem (system: let pkgs = pkgsFor system; in {
            default = pkgs.mkShell {
                packages = map (name: pkgs.${name}) packageNames;
            };
        });
    };
}
