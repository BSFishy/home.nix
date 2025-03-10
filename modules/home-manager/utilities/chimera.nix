{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  chimera-flake = inputs.chimera-flake;
  pkg = chimera-flake.packages.${pkgs.system}.default;
in
{
  config = lib.mkIf isLinux {
    home.packages = [
      pkg
    ];

    programs.bash.initExtra = ''
      alias chimera="sudo ${pkg}/bin/chimera"
    '';

    programs.zsh.initExtra = ''
      alias chimera="sudo ${pkg}/bin/chimera"
    '';
  };
}
