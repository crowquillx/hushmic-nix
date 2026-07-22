{
  description = "Nix package for HushMic";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  nixConfig = {
    extra-substituters = [ "https://hushmic-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "hushmic-nix.cachix.org-1:29j1XWTAAnb869spxlZ937ITJI9MCU1Wre+z7+1HJUM="
    ];
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          hushmic = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.hushmic;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.hushmic}/bin/hushmic";
        };
      });

      checks = forAllSystems (system: {
        inherit (self.packages.${system}) hushmic;
      });

      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "hushmic-nix-fmt";
          runtimeInputs = [
            pkgs.findutils
            pkgs.nixfmt
          ];
          text = ''
            find . -type f -name '*.nix' -print0 | xargs -0 --no-run-if-empty nixfmt
          '';
        }
      );
    };
}
