{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  # home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

/*   home-manager.users = {
    vriess = { lib, ... }: {
      imports = [
        ./general-home.nix
        ./vriess/home.nix
      ];
    };
  }; */

  home-manager.users.vriess = { lib, ... }: {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "23.05";

    # Installed packages
    home.packages = with pkgs; [ 
      micro # Terminal editor
      # unstable.vscode-with-extensions
      vscode-fhs # this works better with nix and extensions
      tmux # Terminal multiplexer
      deno # JS and TS runtime
      google-chrome
      firefox
      gnome.dconf-editor # Dconf editor for dconf debugging
      bitwarden # Password manager
      element-desktop # Matrix client
      baobab # Disk usage analyzer
      gimp # Image manipulation
      inkscape # vector image manipulation
      nixfmt # Nix formatter
      # gnome.gpaste # Clipboard # History, does not work atm
      unstable.gnomeExtensions.pano unstable.libgda unstable.gsound # Clipboard History
      unstable.gnomeExtensions.coverflow-alt-tab # Beautiful Alt-Tab
      unstable.gnomeExtensions.espresso # Keep display on
      gnomeExtensions.removable-drive-menu # Add removable drive menu
      unstable.gnomeExtensions.vitals # CPU, Memory, Disk stats
      # unstable.gnomeExtensions.x11-gestures # X11 touchpad gestures
      gnomeExtensions.noannoyance-2 # Directly switches to new window instead of notification "X is ready"
      gnomeExtensions.pingindic # Ping indicator
      gnomeExtensions.tiling-assistant # Extended window tiling feature
      # ulauncher # Extendable Application Launcher (broken atm)
      localsend # Airdrop alternative
      libreoffice-still
      openssh
      stable.rapid-photo-downloader # Photo importer
      rustup # Rust
      rnix-lsp # Nix language server (auto-formatting, etc.)
      solaar # Logitech unified device GUI
      spotify
      thunderbird-bin
      tree # CLI directory structure visualization
      roboto # Roboto font
      which
      xsane # Scanning utility
      zotero # Bibliography and references tool
      eternal-terminal # Terminal for unstableconnections
      wireguard-tools # Wireguard tools - wg and wg-quick
      samba # smbclient
      ansible # Configuration management
      thonny # Python IDE for Badger2040
      nodejs # NodeJS
      yarn # yarn
      weylus # ipad drawing tablet
      xournalpp # PDF annotations
    ];

    # GNOME settings
    dconf.settings = with lib.hm.gvariant; {
      # Set german keyboard layout in GNOME
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        # sources = [ (mkTuple [ "xkb" "de+nodeadkeys" ]) ]; # nodeadkeys does not easy input of allow french accents
        sources = [ (mkTuple [ "xkb" "de" ]) ];
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
          "tiling-assistant@leleat-on-github"
          "appindicatorsupport@rgcjonas.gmail.com"
      	];
      	disabled-extensions = [
      	  "x11gestures@joseexposito.github.io"
      	  "bluetooth-quick-connect@bjarosze.gmail.com"
      	];
      	favorite-apps = [
      	  "org.gnome.Nautilus.desktop"
      	  "code.desktop"
      	  "firefox.desktop"
      	  "Alacritty.desktop"
      	  "element-desktop.desktop"
      	];
      };
      # Enable fractional scaling
      "org/gnome/mutter" = {
      	experimental-features = [
      	  "scale-monitor-framebuffer"
      	];
      };
    };

    home.sessionPath = [
      "/home/vriess/.deno/bin"
    ];

    # Configure zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      shellAliases = {
        ll = "ls -l";
        nupdate = "sudo nixos-rebuild switch";
        nupdate-git = "cd /etc/nixos/; sudo git add .; sudo git commit -m 'update config'; sudo git push;";
        nupdate-test = "sudo nixos-rebuild test";
        nupgrade = "sudo nixos-rebuild switch --upgrade";
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

    # Configure git
    programs.git = {
      enable = true;
      userName = (builtins.readFile ./nixos-config-private/home-manager_users_vriess_programs_git_userName);
      userEmail = (builtins.readFile ./nixos-config-private/home-manager_users_vriess_programs_git_userEmail);
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };

  home-manager.users.alodahl = { lib, ... }: {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "23.05";

    # Installed packages
    home.packages = with pkgs; [ 
      micro # Terminal editor
      vscode-fhs # this works better with nix and extensions
      # tmux # Terminal multiplexer
      # deno # JS and TS runtime
      google-chrome
      # firefox
      # gnome.dconf-editor # Dconf editor for dconf debugging
      bitwarden # Password manager
      element-desktop # Matrix client
      baobab # Disk usage analyzer
      gimp # Image manipulation
      inkscape # vector image manipulation
      # nixfmt # Nix formatter
      unstable.gnomeExtensions.pano unstable.libgda unstable.gsound # Clipboard History
      unstable.gnomeExtensions.coverflow-alt-tab # Beautiful Alt-Tab
      unstable.gnomeExtensions.espresso # Keep display on
      gnomeExtensions.removable-drive-menu # Add removable drive menu
      unstable.gnomeExtensions.vitals # CPU, Memory, Disk stats
      libreoffice-still
      openssh
      # rapid-photo-downloader # Photo importer
      # rustup # Rust
      # rnix-lsp # Nix language server (auto-formatting, etc.)
      # solaar # Logitech unified device GUI
      spotify
      thunderbird-bin
      tree # CLI directory structure visualization
      roboto # Roboto font
      which
      xsane # Scanning utility
      zotero # Bibliography and references tool
      # eternal-terminal # Terminal for unstableconnections
      wireguard-tools # Wireguard tools - wg and wg-quick
    ];

    # GNOME settings
    dconf.settings = with lib.hm.gvariant; {
      # Set german keyboard layout in GNOME
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        # sources = [ (mkTuple [ "xkb" "de+nodeadkeys" ]) ]; # nodeadkeys does not easy input of allow french accents
        sources = [ (mkTuple [ "xkb" "de" ]) ];
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
      # Enable fractional scaling
      "org/gnome/mutter" = {
      	experimental-features = [
      	  "scale-monitor-framebuffer"
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
        nupdate = "sudo nixos-rebuild switch";
        nupdate-git = "cd /etc/nixos/; sudo git add .; sudo git commit -m 'update config'; sudo git push;";
        nupdate-test = "sudo nixos-rebuild test";
        nupgrade = "sudo nixos-rebuild switch --upgrade";
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
