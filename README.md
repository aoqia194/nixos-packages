A combination of my local nixos packages that I've developed for my system.
If cloning my [nixos-packages](https://github.com/aoqia194/nixos-packages) locally, make sure to override the local path e.g.:

```sh
nix flake lock --override-input aoqia-packages path:../nixos-packages
```
