{
  pkgs,
  lib,
  username ? "bart",
  ...
}:

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
    ../gpg.nix
    ../git.nix
    ../kvm.nix
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
        gh
        google-chrome
        jetbrains.idea-ultimate
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
        thefuck
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
      tf = "thefuck";
    };
  };

  xdg.configFile = {
    "nix-init/config.toml".source = ../nix-init.toml;
    "gh-dash/config.yml".source = ../gh-dash.yml;
  };

  programs.home-manager.enable = true;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;

    settings = with builtins; fromJSON (unsafeDiscardStringContext (readFile ../oh-my-posh.json));
  };

  programs.thefuck = {
    enable = true;
    enableBashIntegration = true;
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
  };

  dont-track-me.enable = true;

  git = {
    enable = true;

    user = {
      email = "50515369+25huizengek1@users.noreply.github.com";
      name = "25huizengek1";
    };

    key = "31805D4650DE1EC8";

    use-gh-cli = true;
    use-gh-dash = true;
    use-gh-branch = true;
    use-gh-notify = true;
  };
}
