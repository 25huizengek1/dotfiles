{
  hosts = {
    "bart-pc" = "x86_64-linux";
    "bart-laptop" = "x86_64-linux";
  };

  homes = {
    "bart@bart-pc" = {
      system = "x86_64-linux";
      username = "bart";
    };
    "bart@bart-laptop" = {
      system = "x86_64-linux";
      username = "bart";
    };
  };
}
