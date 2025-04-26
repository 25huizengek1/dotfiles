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
      "networking"
      "nvidia"
      "printing"
      # "remotebuild"
      "sudo"
    ];

  boot.loader.grub.device = "/dev/nvme0n1";

  bluetooth = {
    enable = true;
    displayName = "PC van Bart";
  };

  hardware = {
    firmware = [ pkgs.rtl8761b-firmware ];
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "25.05";
}
