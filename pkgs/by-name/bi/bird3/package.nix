{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  readline,
  libssh,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "bird";
  version = "3.1.0";

  src = fetchurl {
    url = "https://bird.network.cz/download/bird-${version}.tar.gz";
    hash = "sha256-xxY49Xb0MWcEN++dkL6lZZK8VjcB3nhpg/RCJk7Hdiw=";
  };

  nativeBuildInputs = [
    flex
    bison
  ];
  buildInputs = [
    readline
    libssh
  ];

  patches = [
    ./dont-create-sysconfdir-2.patch
  ];

  CPP = "${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  passthru.tests = nixosTests.bird;

  meta = with lib; {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "https://bird.network.cz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.linux;
  };
}
