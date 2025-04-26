{ ... }:

{
  services.printing = {
    enable = true;
    browsing = true;
    browsed.enable = true;
    allowFrom = [ "all" ];

    cups-pdf.enable = true;
  };
}
