{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.default = pkgs.stdenvNoCC.mkDerivation {
      pname = "fufexan-website";
      version = builtins.substring 0 8 self.lastModifiedDate;

      src = inputs.nix-filter.lib {
        root = self;
        include = [
          (inputs.nix-filter.lib.inDirectory "content")
          (inputs.nix-filter.lib.inDirectory "static")
          (inputs.nix-filter.lib.inDirectory "themes")
          "config.toml"
        ];
      };

      nativeBuildInputs = [pkgs.zola];

      buildPhase = "zola build -o $out";
      dontInstall = true;
    };
  };
}
