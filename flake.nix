{
  description = "Flexisip HTTP file-transfer server";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          package = pkgs.callPackage ./nix/package.nix {
            src = self;
            version = "unstable-${self.lastModifiedDate or "unknown"}";
          };
        in
        {
          default = package;
          flexisip-http-file-transfer-server = package;
        }
      );
    };
}
