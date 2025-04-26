{ pkgs, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
  };
in
{
  programs.adb.enable = true;

  environment.systemPackages = [
    (pkgs.android-studio.withSdk android.androidsdk)
    (pkgs.androidStudioPackages.canary.withSdk android.androidsdk)
    android.androidsdk
  ];
}
