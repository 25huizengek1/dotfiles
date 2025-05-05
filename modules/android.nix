{ pkgs, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
    buildToolsVersions = [
      "35.0.0"
      "35.0.1"
      "36.0.0"
    ];
    platformVersions = [
      "35"
      "36"
    ];
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
