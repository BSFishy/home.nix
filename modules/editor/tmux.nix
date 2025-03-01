{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.distro.editor;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wl-clipboard
      pkgs.xclip
    ];

    programs.tmux = {
      enable = true;

      sensibleOnTop = false;
      terminal = "tmux-256color";
      escapeTime = 10;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      shell = "${pkgs.zsh}/bin/zsh";

      # FIXME: make the copy command configurable
      extraConfig = ''
        # Color support
        set -ga terminal-overrides ",xterm-256color:Tc"

        # For Neovim
        set-option -g focus-events on

        # Reload config file with prefix R
        bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Config reloaded.."

        # Vi-like bindings for copy mode
        bind-key -T copy-mode-vi 'v' send -X begin-selection

        # Vi-like bindings for copy mode with universal clipboard support
        bind-key -T copy-mode-vi y send -X copy-pipe "tmux save-buffer - | sh -c 'if [ -n \"\$WAYLAND_DISPLAY\" ]; then wl-copy; else xclip -selection clipboard; fi'"
      '';
    };
  };
}
