{
    description = "";

    outputs = {
        overlays.default = final: prev: {
            mac-tahoe-icons = final.callPackage ./packages/maco-tahoe-icons {};
            mac-tahoe-cursors = final.callPackage ./packages/maco-tahoe-cursors {};
        };
    };
}
