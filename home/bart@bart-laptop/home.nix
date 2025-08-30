{
  pkgs,
  username ? "bart",
  ...
}:

{
  imports = [
    ../alacritty.nix
    ../common.nix
    ../gpg.nix
    ../plasma.nix
  ];

  common.gui = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
