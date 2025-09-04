{
  description = "Bart Oostveen's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dont-track-me.url = "github:dtomvan/dont-track-me.nix";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-fmt = {
      url = "github:Mic92/flake-fmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    invoice = {
      url = "github:25huizengek1/invoice";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      flake-parts,
      pkgs-by-name-for-flake-parts,
      treefmt,
      flake-fmt,
      invoice,
      copyparty,
      ...
    }@inputs:
    let
      plasmashell-workaround = _final: prev: {
        kdePackages = prev.kdePackages // {
          plasma-workspace =
            let
              unwrapped = prev.kdePackages.plasma-workspace;
            in
            prev.stdenv.mkDerivation {
              inherit (unwrapped) pname version;

              buildInputs = [ unwrapped ];
              nativeBuildInputs = [ prev.makeWrapper ];

              dontUnpack = true;
              dontWrapQtApps = true;
              dontFixup = true;

              installPhase = ''
                # remove duplicates in XDG_DATA_DIRS to speed up the copy process
                export XDG_DATA_DIRS="$(awk -v RS=: '{ if (!arr[$0]++) { printf("%s%s", !ln++ ? "" : ":", $0) }}' <<< "$XDG_DATA_DIRS")"

                # copy output from base package and make it writable
                cp -r ${unwrapped} $out
                chmod u+w $out $out/bin $out/bin/plasmashell

                # copy all XDG_DATA_DIRS into a single directory
                ( IFS=:
                  mkdir $out/xdgdata
                  for DIR in $XDG_DATA_DIRS; do
                    if [[ -d "$DIR" ]]; then
                      cp -r $DIR/. $out/xdgdata/
                      chmod -R u+w $out/xdgdata
                    fi
                  done
                )

                # create a wrapper script that replaces the original XDG_DATA_DIRS with the
                # newly created directory and then calls the original plasmashell binary
                makeWrapper ${unwrapped}/bin/.plasmashell-wrapped $out/bin/plasmashell \
                  --set XDG_DATA_DIRS "$out/xdgdata:/run/current-system/sw/share"
              '';

              passthru = { inherit (unwrapped.passthru) providedSessions; };
            };
        };
      };
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
          config.permittedInsecurePackages = [
            "broadcom-sta-6.30.223.271-57-6.12.44"
          ];
          overlays = [
            self.overlays.default
            (_prev: _final: flake-fmt.packages.${system})
            (_prev: _final: { invoice = invoice.packages.${system}.default; })
            copyparty.overlays.default
            plasmashell-workaround
          ];
        };
      config = import ./config.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        imports = [
          pkgs-by-name-for-flake-parts.flakeModule
          treefmt.flakeModule
        ];

        flake = {
          inherit inputs;

          overlays.default =
            final: prev:
            withSystem prev.stdenv.hostPlatform.system (
              { config, ... }:
              {
                local = config.packages;
              }
            );

          nixosConfigurations = nixpkgs.lib.mapAttrs' (
            host: system:
            nixpkgs.lib.nameValuePair host (
              nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                  inherit host;
                  inherit inputs;
                };
                pkgs = mkPkgs system;
                modules = [
                  sops-nix.nixosModules.sops
                  ./hosts/${host}/${host}.nix
                ];
              }
            )
          ) config.hosts;

          homeConfigurations = nixpkgs.lib.mapAttrs' (
            home: configuration:
            nixpkgs.lib.nameValuePair home (
              home-manager.lib.homeManagerConfiguration {
                extraSpecialArgs = {
                  inherit inputs;
                  inherit (configuration) username;
                };
                pkgs = mkPkgs configuration.system;
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
                  ./home/${home}/home.nix
                  inputs.nix-index-database.homeModules.nix-index
                ];
              }
            )
          ) config.homes;
        };

        systems = [
          "x86_64-linux"
        ];

        perSystem =
          { system, ... }:
          let
            pkgs = mkPkgs system;
          in
          {
            _module.args.pkgs = pkgs;
            pkgsDirectory = ./pkgs;

            treefmt = {
              programs.nixfmt.enable = true;
              programs.deadnix = {
                enable = true;
                no-lambda-arg = true;
                no-lambda-pattern-names = true;
                no-underscore = true;
              };
            };
          };
      }
    );
}
