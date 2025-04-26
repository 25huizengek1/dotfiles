{
  config,
  lib,
  ...
}:

{
  options.bluetooth = with lib; {
    enable = mkEnableOption "Bluetooth Daemon";
    displayName = mkOption {
      description = "Bluetooth display name";
      type = types.str;
      default = "NixOS van Bart";
    };
  };

  config.hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Name = config.bluetooth.displayName;
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  config.services.blueman.enable = true;
}
