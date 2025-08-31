{
  pkgs,
  lib,
  username ? "bart",
  ...
}:

let
  gradleJdks = builtins.listToAttrs (
    map (ver: lib.nameValuePair "JDK${toString ver}" "${pkgs.${"openjdk${toString ver}"}}") [
      8
      17
      21
    ]
  );
in
{
  imports = [
    ../alacritty.nix
    ../common.nix
    ../drop.nix
    ../gpg.nix
    ../jetbrains.nix
    ../kvm.nix
    ../plasma.nix
  ];

  common.gui = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      openjdk23
      wrk

      (prismlauncher.override {
        additionalPrograms = [ ffmpeg ];
        jdks = [
          graalvm-ce
          zulu8
          zulu17
          zulu
        ];
      })
    ];

    file = {
      ".gradle/gradle.properties".text = ''
        org.gradle.console=verbose
        org.gradle.daemon.idletimeout=3600000
        org.gradle.java.installations.fromEnv=${builtins.concatStringsSep "," (lib.attrNames gradleJdks)}
      '';
    };

    sessionVariables = {
      GRADLE_LOCAL_JAVA_HOME = "${pkgs.openjdk23}";
    }
    // gradleJdks;
  };
}
