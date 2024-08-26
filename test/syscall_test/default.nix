{ lib
, stdenv
, fetchFromGitHub
, gvisor-syscall-tests-all
, libgcc
}:
stdenv.mkDerivation rec {
  name = "syscall-tests-for-initrd";

  src = ./.;
  ASTER_PREBUILT_SYSCALL_TEST = "${gvisor-syscall-tests-all}/bin";

  propagatedBuildInputs = [ libgcc ];

  buildPhase = "true";
  installPhase = ''
    make TARGET_DIR=$out
  '';

  dontPatchShebangs = true;
  dontStrip = true;
}
