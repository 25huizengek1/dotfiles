{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = with lib; {
    git.enable = mkEnableOption "Install and configure Git";

    git.user.email = mkOption {
      description = "git config --global user.email";
      type = types.str;
      default = "example@example.com";
    };

    git.user.name = mkOption {
      description = "git config --global user.name";
      type = types.str;
      default = "Unknown";
    };

    git.key = mkOption {
      description = "The signing key used for Git commits";
      type = types.nullOr types.str;
      default = null;
    };

    git.use-gh-cli = mkEnableOption "Install and use the GitHub cli for authentication with GitHub";

    git.use-gh-dash = mkEnableOption "Install gh-dash (only works when use-gh-cli is true)";

    git.use-gh-branch = mkEnableOption "Install gh-branch (only works when use-gh-cli is true)";

    git.use-gh-notify = mkEnableOption "Install gh-notify (only works when use-gh-cli is true)";
  };

  config.programs.git =
    with lib;
    mkIf config.git.enable {
      enable = true;
      delta.enable = true;

      package = pkgs.gitAndTools.gitFull;

      userEmail = config.git.user.email;
      userName = config.git.user.name;

      signing = mkIf (config.git.key != null) {
        key = config.git.key;
        signByDefault = true;
      };

      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "master";
        advice.detachedHead = false;
      };
    };

  config.programs.gh = lib.mkIf config.git.use-gh-cli {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions =
      lib.optional config.git.use-gh-dash pkgs.gh-dash
      ++ lib.optional config.git.use-gh-branch pkgs.local.gh-branch
      ++ lib.optional config.git.use-gh-notify pkgs.gh-notify;
  };
}
