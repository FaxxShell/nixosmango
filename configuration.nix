# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  tuigreet-cmd = pkgs.writeShellScript "tuigreet-launch" ''
    exec ${pkgs.greetd.tuigreet}/bin/tuigreet \
      --time \
      --remember \
      --asterisks \
      --width 60 \
      --theme 'border=#89b4fa;text=#cdd6f4;prompt=#cba6f7;time=#cdd6f4;action=#89b4fa;button=#89b4fa;container=#1e1e2e;input=#cdd6f4' \
      --cmd mango
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet-cmd}";
        user = "greeter";
      };
    };
  };

  # Nvidia-specific Wayland fixes
  environment.sessionVariables = {
    # Fixes invisible cursor
    WLR_NO_HARDWARE_CURSORS = "1";
    # Tells wlroots to use Nvidia
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Improves compatibility for electron apps (Discord, etc.)
    NIXOS_OZONE_WL = "1";
    # Required for some wlroots compositors on Nvidia
    WLR_RENDERER = "vulkan"; 
  };

  # --- Hardware & Graphics (Fixes the warnings) ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Remove the entire 'hardware.opengl' block you had earlier

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.faxxshell = {
    isNormalUser = true;
    description = "faxxshell";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

 #  nixpkgs.overlays = [
 #	(final: prev: {
 #	  dwm = prev.dwm.overrideAttrs (old: {
 #		src = builtins.path { path = /home/faxxshell/dwm; };
 #	});
 #     })
 #  ];

 #  services.xserver = {
 #	enable = true;
 #	windowManager.dwm.enable = true;
 #};


# Enable sound with pipewire.
  services.pulseaudio.enable = false; # Crucial: Disable PulseAudio
  security.rtkit.enable = true;      # Recommended for PipeWire real-time priority
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    wireplumber.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	wget
	git
	xfe
	kitty
	steam
	firefox
	wofi
	wl-clipboard
	waybar
	swaybg
	pfetch
	grimblast
	bluez
	zsh
	mako
	libnotify
	unzip
	oh-my-zsh
	lutris
	spotify
	distrobox
	mangowc
	wlr-randr
	openrgb
  ];


  services.xserver.videoDrivers= [ "nvidia" ];
  hardware.nvidia = {
	modesetting.enable = true;
	open = false;
	nvidiaSettings = true;
	powerManagement.enable = false;
};

  boot.kernelParams = [
	"nvidia_drm.modeset=1"
];

programs.steam.enable = true;

programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" ];
    theme = "agnoster"; # Feel free to change this!
  };
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
