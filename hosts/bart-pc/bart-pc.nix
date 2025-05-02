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
      "i18n"
      "kde"
      "kvm"
      "networking"
      "nvidia"
      "obs-studio"
      "podman"
      "printing"
      # "remotebuild"
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

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "25.05";
}
