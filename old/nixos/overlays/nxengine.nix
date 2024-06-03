let
  version = "2.6.5-rc2";
in

self: super:  rec {
  nxengine-evo  = super.nxengine-evo.overrideAttrs (old: {
    # version = "${version}";

    src = super.fetchurl {
      url = "https://github.com/nxengine/nxengine-evo/archive/v${version}.tar.gz";
      sha256 = "02rk5rx3276s4z0x60i2slsfly976123zizpi7h8alzrmhzjbyld";
    };

    # assets = super.fetchurl {
    #   url = "https://github.com/nxengine/nxengine-evo/releases/download/v${version}/NXEngine-v${version}-Linux.tar.xz";
    #   sha256 = "1b5hkmsrrhnjjf825ri6n62kb3fldwl7v5f1cqvqyv47zv15g5gy";
    # };

    patches = [];
  });
}
