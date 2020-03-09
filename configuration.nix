# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/x220>
      ./hardware-configuration.nix
      ./users.nix
    ];

  boot.initrd.luks.devices.lollypop-encrypted-disk = {
        device = "dev/disk/by-uuid/1f729803-18c6-4832-a7d7-f2871dbf117e";
        keyFile = "/keyfile.bin";
  };

  boot.loader = {
    # Tell NixOS to install Grub as an EFI application in /efi
    efi.efiSysMountPoint = "/efi";

    grub = {
      device = "nodev"; # Do not install Grub for BIOS booting.
      efiSupport = true;
      extraInitrd = "/boot/initrd.keys.gz"; # Add our LUKS key to the initrd
      enableCryptodisk = true; # Allow Grub to boot from LUKS devices.
      zfsSupport = true;
    };

    # Different systems may require a different one of the following two
    # options. The first instructs Grub to install itself in an EFI standard
    # location. And the second tells it to install somewhere custom, but
    # mutate the EFI NVRAM so EFI knows where to find it. The former
    # should work on any system. The latter allows you to share one ESP
    # among multiple OSes, but doesn't work on a few systems (namely
    # VirtualBox, which doesn't support persistent NVRAM).
    #
    # Just make sure to only have one of these enabled.
    grub.efiInstallAsRemovable = true;
    efi.canTouchEfiVariables = false;
  };

  networking.hostName = "lollypop"; # Define your hostname.
  networking.hostId = "59eeabaf";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "uk";
     defaultLocale = "en_GB.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bc
    bwm_ng
    coreutils
    curl
    file
    gitAndTools.gitFull
    gnupg
    htop
    libxml2 # xmllint
    libxslt
    lsof
    mosh
    psmisc # pstree, killall et al
    pwgen
    quilt
    tmux
    tree
    unzip
    utillinux
    vim
    w3m
    wget
    which
    zip

    chromium
    firefox
    gimp
    i3 i3lock i3status dmenu
    inkscape
    keepassx2
    libreoffice
    networkmanagerapplet networkmanager_openvpn
    xdg_utils
    xfontsel
    
    #irc client
    quasselClient

    # gtk icons & themes
    # gtk gnome.gnomeicontheme hicolor_icon_theme shared_mime_info

    dunst libnotify
    xautolock
    xss-lock

    git
    libreoffice          # docs, spreadsheets, etc.
    #dev
    vscode
    zlib

    spotify

    #work
    openfortivpn  
  ];


  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
#       andagii
#       anonymousPro
#       arkpandora_ttf
#       bakoma_ttf
#       cantarell_fonts
#       corefonts
#      clearlyU
#      cm_unicode
       dejavu_fonts
#       freefont_ttf
#       gentium
       inconsolata
       liberation_ttf
#       libertine
#       lmodern
#       mph_2b_damase
#       oldstandard
#       theano
#       tempora_lgc
       terminus_font
       ttf_bitstream_vera
#       ucsFonts
#       unifont
#       vistafonts
#       wqy_zenhei
       latinmodern-math
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support. 
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # no mutable users
  users.mutableUsers = false;

  # Define a user account.
  # users.users.homer = {
  #   isNormalUser = true;
  #   home = "/home/homer";
  #   description = "homer simpson";
  #   extraGroups = [ "wheel" "networkManager" ]; # Enable ‘sudo’ for the user.
  #   hashedPassword = "salted and hashed here";
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
