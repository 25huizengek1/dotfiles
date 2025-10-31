{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.common;
in
{
  imports = [
    ./git.nix
    inputs.sops-nix.homeManagerModules.sops
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
          element-desktop
          keystore-explorer
          libreoffice
          localsend
          mpv
          nerd-fonts.jetbrains-mono
          obsidian
          pavucontrol
          pdfarranger
          signal-desktop
          super-productivity
          telegram-desktop
          thunderbird
          vlc
          wl-clipboard
        ];
    };

    xdg.configFile = {
      "gh-dash/config.yml".source = ./gh-dash.yml;
      "google-chrome/NativeMessagingHosts" = lib.mkIf cfg.gui {
        source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts";
        recursive = true;
      };
    };

    programs.home-manager.enable = true;

    programs.google-chrome.enable = cfg.gui;

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

    programs.keepassxc.enable = lib.mkDefault cfg.gui;

    dont-track-me.enable = true;

    programs.delta.enable = true;
    git = {
      enable = true;
      gh.enable = true;

      user.email = "25huizengek1@gmail.com";
      user.name = "25huizengek1";

      key = "31805D4650DE1EC8";
    };

    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
}
