{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.common;
in
{
  imports = [
    ./git.nix
  ];

  options.common = {
    gui = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to add gui packages";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    home = {
      stateVersion = "25.05";

      sessionVariables = {
        EDITOR = "nano";
        SDL_VIDEODRIVER = "wayland";
      };

      shellAliases = {
        cat = "bat";
      };

      packages =
        with pkgs;
        [
          bat
          btop
          curl
          dust
          ffmpeg
          flake-fmt
          gh
          jq
          meteor-git
          nano
          nix-init
          nurl
          ripgrep
          tomlq
          unzip
          wget
          zip
        ]
        ++ lib.optionals cfg.gui [
          discord
          keystore-explorer
          localsend
          mpv
          nerd-fonts.jetbrains-mono
          pavucontrol
          pdfarranger
          signal-desktop
          telegram-desktop
          thunderbird
          vlc
          wl-clipboard
        ];
    };

    xdg.configFile = {
      "nix-init/config.toml".source = ./nix-init.toml;
      "gh-dash/config.yml".source = ./gh-dash.yml;
    };

    xdg.autostart = {
      enable = true;
      entries = [
        "${pkgs.jetbrains-toolbox}/share/applications/jetbrains-toolbox.desktop"
      ];
    };

    programs.home-manager.enable = true;

    programs.google-chrome = lib.mkIf cfg.gui {
      enable = true;
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    };

    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
    };

    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;

      settings = with builtins; fromJSON (unsafeDiscardStringContext (readFile ./oh-my-posh.json));
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    programs.vscode.enable = lib.mkDefault cfg.gui;

    programs.yt-dlp = {
      enable = true;
      settings = {
        sponsorblock-mark = "all,-preview";
      };
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;

      historyControl = [ "erasedups" ];

      sessionVariables = {
        PROMPT_COMMAND = "history -a; history -n";
      };
    };

    systemd.user.services.nextcloud-client.Unit = lib.mkIf cfg.gui {
      After = [ "tray.target" ];
      Requires = [ "tray.target" ];
    };

    dont-track-me.enable = true;

    git = {
      enable = true;

      user = {
        email = "25huizengek1@gmail.com";
        name = "25huizengek1";
      };

      key = "31805D4650DE1EC8";

      use-gh-cli = true;
      use-gh-dash = true;
      use-gh-branch = true;
      use-gh-notify = true;
    };
  };
}
