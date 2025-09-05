{
  pkgs,
  username ? "bart",
  ...
}:

{
  imports = [
    ../alacritty.nix
    ../common.nix
    ../copyparty-fuse.nix
    ../drop.nix
    ../gpg.nix
    ../jetbrains.nix
    ../plasma.nix
  ];

  common.gui = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
