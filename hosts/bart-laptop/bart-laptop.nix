{
  pkgs,
  ...
}:

{
  imports =
    [
      ./bart-laptop.hardware.nix
    ]
    ++ map (name: ../../modules/${name}.nix) [
      "users/bart"

      "audio"
      "bluetooth"
      "common"
      "i18n"
      "kde"
      "networking"
      "sudo"
      "remotebuild"
    ];

  boot.loader.grub.device = "/dev/sda";

  environment.systemPackages = with pkgs; [
    kdePackages.krfb
    kdePackages.krdc
  ];

  system.stateVersion = "25.11";
}
