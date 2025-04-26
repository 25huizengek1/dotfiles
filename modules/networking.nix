{
  lib,
  host ? "bart-pc",
  ...
}:

{
  networking = {
    hostName = host;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";

    wireless = {
      enable = lib.mkForce false;
      iwd.enable = true;
      iwd.settings = {
        General = {
          UseDefaultInterface = true;
        };
        IPv6 = {
          Enabled = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
      userControlled.enable = true;
    };
  };

  services.tailscale.enable = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [ ];
    };
  };
}
