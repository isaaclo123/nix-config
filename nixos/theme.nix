with import <nixpkgs> {};

let oomox-numix-sulphurpool-theme = stdenv.mkDerivation rec {
  name = "oomox-numix-sulphurpool";
  src = pkgs.fetchFromGitHub {
    owner = "isaaclo123";
    repo = "oomox-numix-sulphurpool-theme";
    rev = "a5cc5b873a702564daf868083103cc1d3f9c93d0";
    sha256 = "1q5kg66fa14qyf81w14x8q1sdkc7kzxnrsmw7bdpf4jr7k5vwwif";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/themes/oomox-numix-sulphurpool/
    cp -r . $out/share/themes/oomox-numix-sulphurpool/
  '';
}; in

let oomox-numix-sulphurpool-icons = stdenv.mkDerivation rec {
  name = "oomox-numix-sulphurpool";
  src = pkgs.fetchFromGitHub {
    owner = "isaaclo123";
    repo = "oomox-numix-sulphurpool-icons";
    rev = "d5a4106b431f551d95a1f43be94849292650eb5f";
    sha256 = "041f1ixsyn7sl9adpghrjp06rvjbrvghgv0fcjdfn8ig0jxz4rm6";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/icons/oomox-numix-sulphurpool/
    cp -r . $out/share/icons/oomox-numix-sulphurpool/
  '';
}; in

{
  # environment.variables = {
  #   NIXPKGS_ALLOW_UNFREE = "1";
  # };

  home-manager.users.isaac = {
    gtk = {
      enable = true;

      theme = {
        name = "oomox-numix-sulphurpool";
        package = (oomox-numix-sulphurpool-theme);
      };

      iconTheme = {
        name = "oomox-numix-sulphurpool";
        package = (oomox-numix-sulphurpool-icons);
      };
    };
  };
}
