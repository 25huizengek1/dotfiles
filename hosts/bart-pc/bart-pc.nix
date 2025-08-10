{
  pkgs,
  ...
}:

{
  imports =
    [
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
      "networking"
      "nvidia"
      "obs-studio"
      "podman"
      "printing"
      "sudo"
    ];

  boot.loader.grub.device = "/dev/nvme0n1";
  boot.extraModprobeConfig = ''
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
  '';

  bluetooth = {
    enable = true;
    displayName = "PC van Bart";
  };

  hardware = {
    firmware = [ pkgs.rtl8761b-firmware ];
    ckb-next.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 5900 ];
  networking.firewall.allowedUDPPorts = [ 5900 ];

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;

  services.davfs2.enable = true;

  services.cloudflare-warp.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

  environment.systemPackages = with pkgs; [
    kdePackages.krfb
    kdePackages.krdc

    wineWowPackages.stableFull
    winetricks
    wineWowPackages.waylandFull

    (writeShellScriptBin "wine64" ''${lib.getExe wineWowPackages.stableFull} "$@"'')
  ];

  programs.steam.enable = true;

  system.stateVersion = "25.05";
}
