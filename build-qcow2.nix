{ config, lib, pkgs, ... }:

with lib;

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "master";
  };

in {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    
    ./nixos/templates/host/configuration.nix
    ./nixos/modules
    
    (import "${home-manager}/nixos")
  ];

  system.build.qcow2 = import <nixpkgs/nixos/lib/make-disk-image.nix> {
    inherit lib config;
    pkgs = import <nixpkgs> {
      inherit (pkgs) system;
    }; # ensure we use the regular qemu-kvm package
    format = "qcow2";
    configFile = ./nixos/templates/host/configuration.nix;
  };
}
