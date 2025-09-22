{
  pkgs,
  lib,
  ...
}:

{
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
  };

  boot.plymouth = {
    enable = true;
    theme = "nixos-bgrt";
    themePackages = with pkgs; [
      nixos-bgrt-plymouth
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.channel.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    age
    comma
    copyparty
    curl
    git
    google-chrome
    home-manager
    invoice
    kdePackages.discover
    nil
    nixd
    nixfmt-rfc-style
    sops
    local.tilp
    vscode
    wget
  ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 3d";
      dates = "weekly";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nix-ld.enable = true;

  programs.nano = {
    enable = true;
    nanorc = ''
      set historylog
      set multibuffer
      set positionlog
      set locking

      set tabsize 4
      set tabstospaces

      set guidestripe 80
      set constantshow
      set linenumbers
      set mouse
      set indicator

      set afterends
      set zap
      set jumpyscrolling
      set smarthome

      set trimblanks
      set colonparsing

      set atblanks
      set softwrap

      extendsyntax nix formatter ${pkgs.nixfmt-rfc-style}
    '';
  };

  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
  };

  services.libinput.enable = true;
  services.flatpak.enable = true;
}
