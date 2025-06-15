{
  pkgs,
  username ? "bart",
  ...
}:

{
  imports = [
    ../alacritty.nix
    ../gpg.nix
    ../git.nix
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
        jq
        keystore-explorer
        localsend
        mpv
        nerd-fonts.jetbrains-mono
        nix-init
        nurl
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
        zip
      ]
      ++ (with pkgs.kdePackages; [
        breeze-gtk
        kde-gtk-config
      ]);

    sessionVariables = {
      EDITOR = "nano";
      SDL_VIDEODRIVER = "wayland";
    };

    shellAliases = {
      cat = "bat";
      tf = "thefuck";
    };
  };

  xdg.configFile = {
    "nix-init/config.toml".source = ../nix-init.toml;
    "gh-dash/config.yml".source = ../gh-dash.yml;
    "google-chrome/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.kdePackages.plasma-browser-integration}/etc/opt/chrome/native-messaging-hosts/org.kde.plasma.browser_integration.json";
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
