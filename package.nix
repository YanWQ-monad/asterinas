{ lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "package";
  version = "0.0.0";

  src = ./package;

  buildPhase = ''
    gcc test.cpp -o test
  '';

  installPhase = ''
    mkdir -p $out
    cp test $out
  '';
}
