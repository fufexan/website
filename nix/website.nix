{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    themeName = (builtins.fromTOML (builtins.readFile "${inputs.theme}/theme.toml")).name;
  in {
    packages.default = pkgs.stdenvNoCC.mkDerivation {
      pname = "fufexan-website";
      version = builtins.substring 0 8 self.lastModifiedDate;

      src = inputs.nix-filter.lib {
        root = self;
        include = [
          (inputs.nix-filter.lib.inDirectory "content")
          (inputs.nix-filter.lib.inDirectory "static")
          (inputs.nix-filter.lib.inDirectory "templates")
          "config.toml"
        ];
      };

      nativeBuildInputs = [pkgs.zola];

      configurePhase = ''
        mkdir -p "themes/${themeName}"
        ln -s ${inputs.theme}/* "themes/${themeName}"
      '';

      buildPhase = "zola build -o $out";
      dontInstall = true;
    };
  };
}
