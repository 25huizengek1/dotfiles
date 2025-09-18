{ inputs, withSystem, ... }:

let
  config = import ../config.nix;
  inherit (inputs.nixpkgs.lib) nameValuePair nixosSystem;
in
{
  flake.nixosConfigurations = inputs.nixpkgs.lib.mapAttrs' (
    host: system:
    withSystem system (
      { pkgs, ... }:

      nameValuePair host (nixosSystem {
        inherit system;
        specialArgs = {
          inherit host;
          inherit inputs;
        };
        inherit pkgs;
        modules = [
          inputs.sops-nix.nixosModules.sops
          ../hosts/${host}/${host}.nix
        ];
      })
    )
  ) config.hosts;
}
