{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.demo = { lib, ... }: {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "18.09";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    dconf.settings = with lib.hm.gvariant; {
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [ (mkTuple [ "xkb" "de" ]) (mkTuple [ "xkb" "de+nodeadkeys" ]) ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
        email = [ "<Super>e" ];
        home = [ "<Super>f" ];
        www = [ "<Super>b" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      	binding = "<Super>t";
      	command = "alacritty";
      	name = "Terminal";
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
        minimize = [ "<Super>less" ];
        switch-applications = [ "<Alt>Tab" ];
        switch-applications-backward = [ "<Shift><Alt>Tab" ];
        switch-windows = [ "<Super>Tab" ];
        switch-windows-backward = [ "<Shift><Super>Tab" ];
      };
    };
    home.packages = with pkgs; [ 
      micro
      vscode-with-extensions
      kitty
      tmux
      google-chrome
      firefox
      gnome.dconf-editor
      bitwarden
      element-desktop
      baobab # Disk usage analyzer
      gimp
      # gnome.gpaste
      # gnomeExtensions.pano libgda gsound
      libreoffice-still
      openssh
      rapid-photo-downloader
      rustup
      solaar
      thunderbird-bin
      tree
      roboto
      which
      xsane
    ];

    # Configure zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 10000;
        # path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
  	    enable = true;
  	    plugins = [ "git" ];
  	    theme = "robbyrussell";
  	  };
    };
  };
}
