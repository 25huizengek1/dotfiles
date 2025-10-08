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
    ];

    hashedPasswordFile = config.sops.secrets.bart-password.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKO4+0nbySi9L5GSXTExGCWdkZBqi5WEqYB9fr4LwKyh bart@bart-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdc+Tbt0d+pHMYrDjrT3Ui09NV38T3bFWk/OMEL4Dp6 u0_a374@bart-phone"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBIJVcr0jxQT1asrf1gXMPk4Ezbmn4XmcAXsR8RCgh++8VBvett9J/QUuAQOim0tIsUWx5C8YDP44QxFNeOh9gAkAAAAEc3NoOg== barto@bart-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4zwjOqILG37umIJNYYSMjveYzmwjOw/pTdfLbcsaSP bart@bart-laptop-new"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJ38XOn6VETxKPzT5SS1s3GexJmUV4P9aTNSe71DpFW bart@bart-pc"
    ];
  };

  sops.secrets.bart-password = {
    sopsFile = ../../secrets/bart.pass;
    neededForUsers = true;

    format = "binary";

    mode = "0600";
    owner = "bart";
    group = "bart";
  };
}
