{ config, pkgs, ... }:

{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "vitune.app";
      sshUser = "nix-remote-builder";
      sshKey = config.sops.secrets.remotebuild.path;
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
    }
  ];

  sops.secrets.remotebuild = {
    owner = "root";
    group = "root";
    mode = "0600";

    sopsFile = ../secrets/remotebuild;
    format = "binary";
  };
}
