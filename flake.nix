{
    description = "aoqia's nixos packages";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
    };

    outputs = inputs: let 
        overlay = final: prev: {
            mac-tahoe-icons = final.callPackage ./packages/mac-tahoe-icons {};
            # mac-tahoe-cursors = final.callPackage ./packages/mac-tahoe-cursors {};
        };

        systems = [ "x86_64-linux" "aarch64-linux" ];
        forEachSystem = f: inputs.nixpkgs.lib.genAttrs systems f;
        pkgsFor = system: import inputs.nixpkgs {
            inherit system;
            overlays = [ overlay ];
            config.allowUnfree = true;
        };
    in {
        overlays.default = overlay;

        packages = forEachSystem (system: let pkgs = pkgsFor system; in {
            inherit (pkgs) mac-tahoe-icons;
            default = pkgs.mac-tahoe-icons;
        });

        devShells = forEachSystem (system: let pkgs = pkgsFor system; in {
            default = pkgs.mkShell {
                packages = [ pkgs.mac-tahoe-icons ];
            };
        });
    };
}
