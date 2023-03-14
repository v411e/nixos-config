{ config, pkgs, lib, ... }:

  {
    imports = [
      <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>
      ./home.nix
  ];
  
    # Let demo build as a trusted user.
  # nix.settings.trusted-users = [ "demo" ];
  
  # Mount a VirtualBox shared folder.
  # This is configurable in the VirtualBox menu at
  # Machine / Settings / Shared Folders.
  # fileSystems."/mnt" = {
  #   fsType = "vboxsf";
  #   device = "nameofdevicetomount";
  #   options = [ "rw" ];
  # };
  
  # By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
  # If you prefer another desktop manager or display manager, you may want
  # to disable the default.
  services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;
  
  # Enable GDM/GNOME by uncommenting above two lines and two lines below.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  
  # List packages installed in system profile. To search, run:
  # \$ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    git
    micro
    alacritty
    htop
    gnomeExtensions.appindicator
    neofetch
    rsync
  ];
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  # Enable nix-command
  nix.settings.experimental-features = [ "nix-command" ];

  # Set german keyboard layout
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys,";
  };

  # Enable unfree packages for vscode
  nixpkgs.config.allowUnfree = true;

  # Use X11 instead of wayland
  services.xserver.displayManager.gdm.wayland = false;

  # Gnome Extension for systray icons
  # environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Save storage
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Set default shell to zsh
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
}
