{ config, pkgs, lib, ... }:

let
  libdecsync = pkgs.python3Packages.buildPythonPackage rec {
    pname = "libdecsync";
    version = "2.2.1";
    format = "setuptools";

    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-Mukjzjumv9VL+A0maU0K/SliWrgeRjAeiEdN5a83G0I=";
    };
  };
  radicale-storage-decsync = pkgs.python3Packages.buildPythonPackage rec {
    pname = "radicale_storage_decsync";
    version = "2.1.0";
    format = "setuptools";

    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-X+0MT5o2PjsKxca5EDI+rYyQDmUtbRoELDr6e4YXKCg=";
    };

    #src = pkgs.fetchFromGitHub{
    #  "owner" = "mab122";
    #  "repo" = "Radicale-DecSync";
    #  "rev" = "6c3a7874ed752c6418e570e63f272dac92124f11";
    #  "hash" = "sha256-JQSA3/01q7593NXxq+mCx7fmvjO7ij8PidJe7hja2Oc=";
    #};

    buildInputs = [ pkgs.unstable.radicale ];
    propagatedBuildInputs = [ libdecsync pkgs.python3Packages.setuptools ];
  };
  radicale-decsync = pkgs.unstable.radicale.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ radicale-storage-decsync ];
    makeWrapperArgs = "--prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath [ pkgs.libxcrypt-legacy ]}";
  });
  radicale-config = pkgs.writeText "radicale-config"
    ''
      [storage]
      type = radicale_storage_decsync
      filesystem_folder = ${config.xdg.dataHome}/radicale
      decsync_dir = ${config.xdg.dataHome}/DecSync
      [auth]
      type = none
    '';
in
  {

    home.packages = with pkgs; [ radicale-storage-decsync radicale-decsync ];

    systemd.user.services.radicale = {
      Unit.Description = "Radicale with DecSync";
      Service = {
        ExecStart = "${radicale-decsync}/bin/radicale -C ${radicale-config}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };
  }

# { pkgs, ...}: {
#   home.packages = with pkgs; [radicale python3Packages.radicale-storage-decsync];
# 
#   xdg.configFile = {
#     "radicale/config".text =
#     ''
#     [server]
#     # Bind all addresses
#     hosts = 0.0.0.0:5232, [::]:5232
# 
#     [auth]
#     type = htpasswd
#     htpasswd_filename = ~/Radicale/.htpasswd
#     htpasswd_encryption = autodetect
# 
#     [storage]
#     filesystem_folder = ~/Radicale
#     '';
#   };
# }
# 
