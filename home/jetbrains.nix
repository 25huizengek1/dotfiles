{ pkgs, ... }:

{
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.jetbrains-toolbox}/share/applications/jetbrains-toolbox.desktop"
    ];
  };

  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.idea-ultimate
  ];
}
