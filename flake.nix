{
  description = "Asterinas Operating System";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      overlays = [ (import rust-overlay) ];
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      });

    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in rec {
          rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
          initrd = (pkgs.callPackage ./test/initrd.nix { });
          shell = self.devShells.${system}.default;
        }
      );

      devShells = forAllSystems (system: { default =
        let
          pkgs = nixpkgsFor.${system};
          pkgsFlake = self.packages.${system};
          rustPlatform = pkgs.makeRustPlatform {
            cargo = pkgsFlake.rustToolchain;
            rustc = pkgsFlake.rustToolchain;
          };
        in pkgs.mkShell {
          packages = [
            # Rust Toolchain
            pkgsFlake.rustToolchain
            (pkgs.cargo-binutils.override { inherit rustPlatform; })

            # QEMU
            pkgs.qemu

            # Binaries required to build image
            (pkgs.grub2.override { efiSupport = true; })
            pkgs.libisoburn
            pkgs.mtools
            pkgs.exfatprogs
          ];

          shellHook = ''
            export OVMF_PATH=${pkgs.OVMF.fd}/FV
            export PREBUILT_INITRAMFS=${pkgsFlake.initrd}/initrd.gz
          '';
        };
      });
    };
}
