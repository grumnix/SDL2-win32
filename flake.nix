{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";

    SDL2_src.url = "https://libsdl.org/release/SDL2-devel-2.32.8-mingw.tar.gz";
    SDL2_src.flake = false;
  };

  outputs = { self, nixpkgs, tinycmmc, SDL2_src }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = SDL2;

          SDL2 = pkgs.stdenv.mkDerivation {
            pname = "SDL2";
            version = "2.32.8";

            src = SDL2_src;

            installPhase = ''
              mkdir $out
              cp -vr ${pkgs.stdenv.targetPlatform.config}/. $out/
              substituteInPlace $out/lib/pkgconfig/sdl2.pc \
                --replace "prefix=/opt/local/${pkgs.stdenv.targetPlatform.config}" \
                          "prefix=$out"
            '';
          };
        };
      }
    );
}
