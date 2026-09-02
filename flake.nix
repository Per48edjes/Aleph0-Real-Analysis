{
  description = "Aleph 0 real analysis notes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = function: nixpkgs.lib.genAttrs systems (system:
        function nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs:
        let
          tex = pkgs.texliveSmall.withPackages (ps: with ps; [
            latexmk
            amsmath
            amsfonts
            enumitem
            geometry
            fancyhdr
            hyperref
            tcolorbox
            csquotes
            footmisc
            xcolor
          ]);
          pdf = pkgs.stdenvNoCC.mkDerivation {
            pname = "aleph0-real-analysis";
            version = "0.1.0";
            src = self;
            nativeBuildInputs = [ tex ];

            buildPhase = ''
              export HOME="$TMPDIR/home"
              export TEXMFHOME="$TMPDIR/texmf-home"
              export TEXMFVAR="$TMPDIR/texmf-var"
              mkdir -p "$HOME" "$TEXMFHOME" "$TEXMFVAR"
              latexmk -pdf -interaction=nonstopmode main.tex
            '';

            installPhase = ''
              mkdir -p "$out"
              cp main.pdf "$out/main.pdf"
            '';
          };
        in
        {
          default = pdf;
          inherit pdf tex;
        });

      devShells = forAllSystems (pkgs:
        let
          tex = self.packages.${pkgs.stdenv.hostPlatform.system}.tex;
        in
        {
          default = pkgs.mkShell {
            packages = [ tex ];
          };
        });
    };
}
