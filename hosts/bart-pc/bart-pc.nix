{
  pkgs,
  ...
}:

{
  imports = [
    ./bart-pc.hardware.nix
  ]
  ++ map (name: ../../modules/${name}.nix) [
    "users/bart"

    "android"
    "audio"
    "bluetooth"
    "common"
    "copyparty-fuse"
    "i18n"
    "kde"
    "kvm"
    "network-profiles"
    "networking"
    "nvidia"
    "obs-studio"
    "podman"
    "printing"
    "sudo"
  ];

  boot.loader.grub =
    let
      gfxmode = "1920x1080-75";
    in
    {
      device = "/dev/nvme0n1";
      gfxmodeEfi = gfxmode;
      gfxmodeBios = gfxmode;
    };

  boot.extraModprobeConfig = ''
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
  '';

  hardware.firmware = [ pkgs.rtl8761b-firmware ];

  services.davfs2.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.krfb
    kdePackages.krdc

    wineWowPackages.stableFull
    winetricks
    wineWowPackages.waylandFull

    (writeShellScriptBin "wine64" ''${lib.getExe wineWowPackages.stableFull} "$@"'')
  ];

  networking.firewall.allowedTCPPorts = [ 5900 ];
  networking.firewall.allowedUDPPorts = [ 5900 ];

  programs.steam.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  system.stateVersion = "25.05";
}
