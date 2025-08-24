{ config, pkgs, ... }:

{
  nix.settings.trusted-users = [ "bart" ];

  users.users.bart = {
    isNormalUser = true;
    description = "Bart Oostveen";

    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "adbusers"
      "docker"
      "audio"
      "bluetooth"
      "seat"
      "lp"
      "scanner"
    ];

    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];

    hashedPasswordFile = config.sops.secrets.bart-password.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKO4+0nbySi9L5GSXTExGCWdkZBqi5WEqYB9fr4LwKyh bart@bart-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdc+Tbt0d+pHMYrDjrT3Ui09NV38T3bFWk/OMEL4Dp6 u0_a374@bart-phone"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBG012Fvtbxykbn9hjOKRTe1ZK0ZksMK1j/ZnVrYqzuADZDuYCdGH5TB5znV+NbJuBmRuAWerBLr/rMTpY4frST4AAAAEc3NoOg== barto@bart-laptop"
    ];
  };

  sops.secrets.bart-password = {
    sopsFile = ../../secrets/bart.pass;
    neededForUsers = true;

    format = "binary";

    mode = "0600";
    owner = "bart";
    group = "users";
  };
}
