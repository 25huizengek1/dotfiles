{ inputs, withSystem, ... }:

let
  config = import ../config.nix;
  inherit (inputs.nixpkgs.lib) mapAttrs' nameValuePair;
in
{
  flake.homeConfigurations = mapAttrs' (
    home: configuration:
    withSystem configuration.system (
      { pkgs, ... }:

      nameValuePair home (
        inputs.home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            inherit (configuration) username;
          };
          inherit pkgs;
          modules = [
            (
              { options, ... }:
              {
                options.programs.google-chrome.nativeMessagingHosts =
                  options.programs.chromium.nativeMessagingHosts;
              }
            )
            inputs.plasma-manager.homeModules.plasma-manager
            inputs.dont-track-me.homeManagerModules.default
            inputs.sops-nix.homeManagerModules.sops
            ../home/${home}/home.nix
            inputs.nix-index-database.homeModules.nix-index
          ];
        }
      )
    )
  ) config.homes;
}
