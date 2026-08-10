{ lib, stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation {
    pname = "mac-tahoe-icons";
    version = "unstable-2026-08-10";

    src = fetchFromGitHub {
        owner = "vinceliuice";
        repo = "MacTahoe-icon-theme";
        rev = "1d8b6b966f156e5db214785a8e9598aed9952428";
        hash = "sha256-OtOGj33VxW5bT18iieKTDeHwqsoLgUG/Xno3LICZtZc=";
    };

    dontConfigure = true;
    dontBuild = true;
    # Disable fixup phase otherwise it will process all 30k svg files.
    dontFixup = true;

    patchPhase = ''
        runHook prePatch

        # Do not run gtk-update-icon-cache
        sed -i '/gtk-update-icon-cache/d' install.sh
        # Do not install cursors
        sed -i 's/install_theme && install_cursor_theme/install_theme/' install.sh

        runHook postPatch
    '';

    installPhase = ''
        runHook preInstall

        install -d "$out/share/icons"
        bash install.sh -d "$out/share/icons" -t all

        runHook postInstall
    '';

    # Remove broken symlinks that upstream repo has in links/ folder
    postInstall = ''
        find "$out/share/icons" -xtype l -delete
    '';

    meta = with lib; {
        description = "MacOS Tahoe icon theme for linux";
        homepage = "https://github.com/aoqia194/mac-tahoe-icons";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
        maintainers = with lib.maintainers; [
            aoqia
        ];
    };
}
