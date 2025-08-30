{
  pkgs,
  ...
}:

{
  imports = [
    ./bart-laptop-new.hardware.nix
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

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  time.hardwareClockInLocalTime = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.krfb
    kdePackages.krdc
  ];

  system.stateVersion = "25.11";
}
