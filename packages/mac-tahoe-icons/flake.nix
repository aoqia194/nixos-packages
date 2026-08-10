{
    description = "";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-26.05";
    };

    outputs = inputs:
    let
        systemArch = "x86_64-linux";
    in {
        packages."${systemArch}".default = inputs.nixpkgs.legacyPackages."${systemArch}".callPackage ./default.nix {};
    };
}
