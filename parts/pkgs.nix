{
  self,
  inputs,
  withSystem,
  ...
}:

{
  imports = [
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  perSystem =
    { system, ... }:

    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
        config.permittedInsecurePackages = [
          "broadcom-sta-6.30.223.271-57-6.12.47"
        ];
        overlays = [
          self.overlays.default
          (_prev: _final: inputs.flake-fmt.packages.${system})
          (_prev: _final: { invoice = inputs.invoice.packages.${system}.default; })
          inputs.copyparty.overlays.default
          self.overlays.plasmashell-workaround
        ];
      };

      pkgsDirectory = ../pkgs;
    };

  systems = [ "x86_64-linux" ];

  flake = {
    overlays.default =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { config, ... }:
        {
          local = config.packages;
        }
      );
  };
}
