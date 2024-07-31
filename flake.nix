{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        devenv.shells.default = {
          packages = [];

          android = {
            enable = true;
            platforms.version = [ "31" "32" "34" ];
            flutter.enable = true;
            emulator.enable = true;
            sources.enable = true;
            systemImages.enable = true;
            android-studio.enable = true;
          };

          languages = {
          };

          processes = {
          };

          enterShell = ''
          '';
        };
      };
    };
}
