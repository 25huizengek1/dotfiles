{ pkgs, ... }:

let
  url = "https://fs.omeduostuurcentenneef.nl/share/";
  user = "adm";
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "duo";

      runtimeInputs = with pkgs; [
        coreutils
        curl
        file
        gawk
        gnugrep
        libnotify
        wl-clipboard
      ];

      text = ''
        if ! wl-paste -l | grep '^image/'; then
          echo not an image
          notify-send duo "not an image"
          exit 1
        fi

        extension="$(wl-paste | file -b --extension - | awk -F/ '{ print $1 }')"
        wl-paste \
          | curl -sT- ${url}."$extension"?want=url -u ${user} -p \
          | tee >(wl-copy)

        sleep .5

        notify-send duo "successfully uploaded to $(wl-paste | tr -dc '[:print:]')"
      '';
    })
  ];

  xdg.desktopEntries.duo = {
    name = "Duo";
    comment = "Upload screenshot to omeduostuurcentenneef.nl";
    exec = "duo";
    icon = ./copyparty.png;
    terminal = true;
  };
}
