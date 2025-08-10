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
    curl
    git
    google-chrome
    home-manager
    invoice
    kdePackages.discover
    nano
    nil
    nixd
    nixfmt-rfc-style
    sops
    local.tilp
    vscode
    wget

    # Copyparty
    copyparty
    partyfuse
    u2c
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
