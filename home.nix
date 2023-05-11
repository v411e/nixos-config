{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.vriess = { lib, ... }: {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "22.11";

    # Installed packages
    home.packages = with pkgs; [
      micro # Terminal editor
      vscode-with-extensions
      tmux # Terminal multiplexer
      google-chrome
      firefox
      gnome.dconf-editor # Dconf editor for dconf debugging
      bitwarden # Password manager
      element-desktop # Matrix client
      baobab # Disk usage analyzer
      gimp # Image manipulation
      unstable.gnomeExtensions.pano libgda gsound # Clipboard History
      unstable.gnomeExtensions.coverflow-alt-tab # Beautiful Alt-Tab
      unstable.gnomeExtensions.bluetooth-quick-connect # Bluetooth Quick-Connect Tile
      unstable.gnomeExtensions.espresso # Keep display on
      unstable.gnomeExtensions.removable-drive-menu # Add removable drive menu
      unstable.gnomeExtensions.vitals # CPU, Memory, Disk stats
      unstable.gnomeExtensions.x11-gestures # X11 touchpad gestures
      libreoffice-still
      openssh
      rapid-photo-downloader # Photo importer
      rustup # Rust
      solaar # Logitech unified device GUI
      spotify
      thunderbird-bin
      tree # CLI directory structure visualization
      roboto # Roboto font
      which
      xsane # Scanning utility
    ];

    # GNOME settings
    dconf.settings = with lib.hm.gvariant; {
      # Set german keyboard layout in GNOME
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [ (mkTuple [ "xkb" "de+nodeadkeys" ]) ];
      };

      # Custom keybindings
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
      # Other custom GNOME settings
      "org/gnome/desktop/interface" = {
      	clock-show-weekday = true;
      	cursor-size = 48;
      	enable-animations = false;
      	show-battery-percentage = true;
      };
      "org/gnome/desktop/notifications" = {
      	show-in-lock-screen = false;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        speed = 0.5;
      	tap-to-click = true;
      };
      "org/gnome/desktop/privacy" = {
      	old-files-age= mkUint32(30);
      	remove-old-temp-files = true;
      	remove-old-trash-files = true;
      };
      "org/gnome/desktop/wm/preferences" = {
      	button-layout = "appmenu:minimize,close";
      };
      "system/locale" = {
      	region = "de_DE.UTF-8";
      };
      "org/gnome/shell" = {
      	enabled-extensions = [
      	  "pano@elhan.io"
      	  "espresso@coadmunkee.github.com"
      	  "Vitals@CoreCoding.com"
      	  "CoverflowAltTab@palatis.blogspot.com"
      	  "drive-menu@gnome-shell-extensions.gcampax.github.com"
      	];
      	disabled-extensions = [
      	  "x11gestures@joseexposito.github.io"
      	  "bluetooth-quick-connect@bjarosze.gmail.com"
      	];
      	favorite-apps = [
      	  "org.gnome.Nautilus.desktop"
      	  "code.desktop"
      	  "google-chrome.desktop"
      	  "Alacritty.desktop"
      	  "element-desktop.desktop"
      	];
      };
    };

    # Configure zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        update-git = "cd /etc/nixos/; sudo git add .; sudo git commit -m 'update config'; sudo git push;";
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
