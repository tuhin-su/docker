{ config, pkgs, ... }:

{
  ##################################################
  # SYSTEM BASICS
  ##################################################
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  ##################################################
  # NIX FEATURES (FLAKES)
  ##################################################
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    keep-outputs = true;
    keep-derivations = true;
    cores = 0;
    max-jobs = "auto";
  };

  ##################################################
  # BOOT
  ##################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ##################################################
  # CPU + KVM (AMD)
  ##################################################
  boot.kernelModules = [ "kvm-amd" ];
  hardware.cpu.amd.updateMicrocode = true;

  ##################################################
  # GPU (AMD + NVIDIA PRIME)
  ##################################################
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  ##################################################
  # DESKTOP (XFCE4)
  ##################################################
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  ##################################################
  # NETWORK
  ##################################################
  networking.hostName = "nobel";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  hardware.enableRedistributableFirmware = true;

  ##################################################
  # AUDIO
  ##################################################
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ##################################################
  # POWER
  ##################################################
  services.power-profiles-daemon.enable = true;
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
  };

  ##################################################
  # SWAP (+16GB)
  ##################################################
  swapDevices = [
    { device = "/swapfile"; size = 16384; }
  ];

  boot.kernel.sysctl."vm.swappiness" = 10;

  ##################################################
  # VIRTUALIZATION
  ##################################################
  users.groups.kvm = {};
  users.groups.libvirtd = {};

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      ovmf.enable = true;
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  ##################################################
  # CUDA
  ##################################################
  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
  ];

  environment.variables = {
    CUDA_HOME = "/run/opengl-driver";
    CUDA_PATH = "/run/opengl-driver";
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver/lib64";
  };

  ##################################################
  # WIRESHARK
  ##################################################
  programs.wireshark.enable = true;

  ##################################################
  # USER: master (password = 1234)
  ##################################################
  users.users.master = {
    isNormalUser = true;
    description = "Master User";
    shell = pkgs.zsh;
    initialPassword = "1234";

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "kvm"
      "libvirtd"
      "wireshark"
    ];

    packages = with pkgs; [
      git
      zsh
      oh-my-zsh
      powerlevel10k

      google-chrome
      vscode

      podman
      podman-compose

      qemu
      qemu_kvm
      virt-manager
      virt-viewer

      tcpdump
      wireshark
      wireshark-cli

      # Network tools
      nmap
      netcat
      iproute2
      dnsutils
      traceroute
      whois
      iperf3

      xfce.thunar
      xfce.xfce4-terminal
    ];
  };

  ##################################################
  # ZSH + OH-MY-ZSH (POPULAR PLUGINS)
  ##################################################
  programs.zsh.enable = true;

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "powerlevel10k/powerlevel10k";
    plugins = [
      "git"
      "sudo"
      "history"
      "extract"
      "colored-man-pages"
      "command-not-found"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
    ];
  };

  ##################################################
  # FONTS
  ##################################################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  ##################################################
  # SECURITY
  ##################################################
  security.sudo.wheelNeedsPassword = true;
  security.polkit.enable = true;

  ##################################################
  # BASE TOOLS
  ##################################################
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    pciutils
    usbutils
  ];
}
