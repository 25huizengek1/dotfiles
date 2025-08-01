{
  pkgs,
  lib,
  username ? "bart",
  ...
}:

# TODO: for the love of god: merge these configs

let
  gradleJdks = builtins.listToAttrs (
    map (ver: lib.nameValuePair "JDK${toString ver}" "${pkgs.${"openjdk${toString ver}"}}") [
      8
      17
      21
    ]
  );
in
{
  imports = [
    ../alacritty.nix
    ../drop.nix
    ../gpg.nix
    ../git.nix
    ../kvm.nix
    ../plasma.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "25.05";

    packages =
      with pkgs;
      [
        bat
        btop
        curl
        discord
        dust
        ffmpeg
        flake-fmt
        gh
        jetbrains-toolbox
        jetbrains.idea-ultimate
        jetbrains.rust-rover
        jq
        keystore-explorer
        localsend
        mpv
        nerd-fonts.jetbrains-mono
        nix-init
        nurl
        openjdk23
        pavucontrol
        pdfarranger
        ripgrep
        signal-desktop
        telegram-desktop
        tomlq
        unzip
        vlc
        wget
        wl-clipboard
        wrk
        zip

        (prismlauncher.override {
          additionalPrograms = [ ffmpeg ];
          jdks = [
            graalvm-ce
            zulu8
            zulu17
            zulu
          ];
        })
      ]
      ++ (with pkgs.kdePackages; [
        breeze-gtk
        kde-gtk-config
      ]);

    file = {
      ".gradle/gradle.properties".text = ''
        org.gradle.console=verbose
        org.gradle.daemon.idletimeout=3600000
        org.gradle.java.installations.fromEnv=${builtins.concatStringsSep "," (lib.attrNames gradleJdks)}
      '';
    };

    sessionVariables = {
      EDITOR = "nano";
      SDL_VIDEODRIVER = "wayland";
      GRADLE_LOCAL_JAVA_HOME = "${pkgs.openjdk23}";
    } // gradleJdks;

    shellAliases = {
      cat = "bat";
    };
  };

  xdg.configFile = {
    "nix-init/config.toml".source = ../nix-init.toml;
    "gh-dash/config.yml".source = ../gh-dash.yml;
  };

  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.jetbrains-toolbox}/share/applications/jetbrains-toolbox.desktop"
    ];
  };

  programs.home-manager.enable = true;

  programs.google-chrome = {
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

    settings = with builtins; fromJSON (unsafeDiscardStringContext (readFile ../oh-my-posh.json));
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.vscode.enable = true;

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

  systemd.user.services.nextcloud-client.Unit = {
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
}
