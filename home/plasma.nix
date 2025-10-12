{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.breeze-gtk
    kdePackages.kde-gtk-config
  ];

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Breeze-Dark";
        size = 24;
      };
      iconTheme = "breeze-dark";
    };

    shortcuts = {
      "services/Alacritty.desktop"."New" = "Meta+Return";
    };

    configFile = {
      "kdeglobals"."General"."AccentColor" = "0,85,255";
      "kdeglobals"."General"."TerminalApplication" = "alacritty";
      "kdeglobals"."General"."TerminalService" = "Alacritty.desktop";
      "kiorc"."Confirmations"."ConfirmDelete" = false;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "ksmserverrc"."General"."loginMode" = "emptySession";
      "kwinrc"."Desktops"."Id_1" = "32f7aab7-d3d2-463f-897b-3795a776364c";
      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Desktops"."Rows" = 2;
      "kwinrc"."Effect-slide"."HorizontalGap" = 0;
      "kwinrc"."Effect-slide"."VerticalGap" = 0;
      "kwinrc"."ElectricBorders"."Bottom" = "ApplicationLauncher";
      "kwinrc"."ElectricBorders"."Top" = "KRunner";
      "kwinrc"."Plugins"."blurEnabled" = true;
      "kwinrc"."Plugins"."mousemarkEnabled" = true;
      "kwinrc"."Plugins"."sheetEnabled" = true;
      "kwinrc"."Plugins"."wobblywindowsEnabled" = true;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Windows"."RollOverDesktops" = true;
      "kwinrc"."Xwayland"."Scale" = 1.5;
      "kxkbrc"."Layout"."DisplayNames" = ",";
      "kxkbrc"."Layout"."LayoutList" = "us,us";
      "kxkbrc"."Layout"."Use" = true;
      "kxkbrc"."Layout"."VariantList" = "euro,intl";
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasmanotifyrc"."Jobs"."PermanentPopups" = false;
      "spectaclerc"."GuiConfig"."captureMode" = 0;
      "spectaclerc"."ImageSave"."imageSaveLocation" = "file:///home/bart/Pictures/Screenshots";
    };
  };
}
