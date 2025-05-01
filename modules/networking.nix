{
  lib,
  host ? "bart-pc",
  ...
}:

{
  networking = {
    hostName = host;
    networkmanager.enable = true;
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
