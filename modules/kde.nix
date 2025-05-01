{ ... }:

{
  services.xserver = {
    enable = true;
    # displayManager.lightdm = {
      # enable = true;
      # greeter = {
        # name = "lightdm-kde-greeter";
        # package = pkgs.dtomvan.lightdm-kde-greeter.xgreeters;
      # };
    # };
    xkb = {
      layout = "us";
      variant = "euro";
    };
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;
}
