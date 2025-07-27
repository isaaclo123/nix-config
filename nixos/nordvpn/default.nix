# https://gist.github.com/chomes/2e1b0e0f532c9fbbf25fe33e49cb8198
# How to use
# Create a file in your nix config folder called nordvpn.nix and paste the contents there
# In your configuration.nix add it to your imports
#   imports =
#     [ # Include the results of the hardware scan.
#       ./hardware-configuration.nix
#       ./nordvpn-module.nix
#     ];
# Run sudo nixos-rebuild switch and it will install the package, then just login and start using!
# Updating the package
# I'll try and keep this up to date, but if you need to do it yourself on line 27 you'll need to change the version. You can find the latest version of the deb files here get the version number i.e. 4.1.2 and replace the version
# 
# Make the hash in line 34 an empty string "" and then do sudo nixos-rebuild switch it will fail due to the hash being in correct, paste the correct hash into the string and then re-run sudo nixos-rebuild switch and it should build

{
  config,
  lib,
  pkgs,
  ...
}: let
  nordVpnPkg = pkgs.callPackage ({
    autoPatchelfHook,
    buildFHSEnvChroot,
    dpkg,
    fetchurl,
    lib,
    stdenv,
    sysctl,
    iptables,
    iproute2,
    procps,
    cacert,
    libnl, # Needed for 3.9.x +
    libcap_ng, # Needed for 3.9.x +
    libxml2,
    libidn2,
    zlib,
    wireguard-tools,
  }: let
    pname = "nordvpn";
    version = "4.0.0";

nordVPNBase = stdenv.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/nordvpn_${version}_amd64.deb";
        hash = "sha256-elKREKiFrx2TgJPJl1ARtEebsv4PNG9fMq2mrV9xngs=";
      };

      buildInputs = [libxml2 libidn2 libnl libcap_ng];
      nativeBuildInputs = [dpkg autoPatchelfHook stdenv.cc.cc.lib];

      dontConfigure = true;
      dontBuild = true;

      unpackPhase = ''
        runHook preUnpack
        dpkg --extract $src .
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        mv usr/* $out/
        mv var/ $out/
        mv etc/ $out/
        runHook postInstall
      '';
    };

    nordVPNfhs = buildFHSEnvChroot {
      name = "nordvpnd";
      runScript = "nordvpnd";

      # hardcoded path to /sbin/ip
      targetPkgs = pkgs: [
        nordVPNBase
        sysctl
        iptables
        iproute2
        procps
        cacert
        libnl # Needed for 3.9.x +
        libcap_ng # Needed for 3.9.x +
        libxml2
        libidn2
        zlib
        wireguard-tools
      ];
    };
  in
    stdenv.mkDerivation {
      inherit pname version;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share
        ln -s ${nordVPNBase}/bin/nordvpn $out/bin
        ln -s ${nordVPNfhs}/bin/nordvpnd $out/bin
        ln -s ${nordVPNBase}/share/* $out/share/
        ln -s ${nordVPNBase}/var $out/
        runHook postInstall
      '';

      meta = with lib; {
        description = "CLI client for NordVPN";
        homepage = "https://www.nordvpn.com";
        license = licenses.unfreeRedistributable;
        maintainers = with maintainers; [dr460nf1r3];
        platforms = ["x86_64-linux"];
      };
    }) {};
in
  with lib; {
    options.myypo.services.custom.nordvpn.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the NordVPN daemon. Note that you'll have to set
        `networking.firewall.checkReversePath = false;`, add UDP 1194
        and TCP 443 to the list of allowed ports in the firewall and add your
        user to the "nordvpn" group (`users.users.<username>.extraGroups`).
      '';
    };

    config = mkIf config.myypo.services.custom.nordvpn.enable {
      networking.firewall.checkReversePath = false;

      environment.systemPackages = [nordVpnPkg];

      users.groups.nordvpn = {};
      users.groups.nordvpn.members = ["myypo"];
      systemd = {
        services.nordvpn = {
          description = "NordVPN daemon.";
          serviceConfig = {
            ExecStart = "${nordVpnPkg}/bin/nordvpnd";
            ExecStartPre = pkgs.writeShellScript "nordvpn-start" ''
              mkdir -m 700 -p /var/lib/nordvpn;
              if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
                cp -r ${nordVpnPkg}/var/lib/nordvpn/* /var/lib/nordvpn;
              fi
            '';
            NonBlocking = true;
            KillMode = "process";
            Restart = "on-failure";
            RestartSec = 5;
            RuntimeDirectory = "nordvpn";
            RuntimeDirectoryMode = "0750";
            Group = "nordvpn";
          };
          wantedBy = ["multi-user.target"];
          after = ["network-online.target"];
          wants = ["network-online.target"];
        };
      };
    };
  }
