#!/usr/bin/env bash

if [ -z "$(ls -A nixos)" ]; then
   nix-shell -p git --command "git clone https://github.com/$1.git nixos"
   cp detect-modules.nix nixos/modules/default.nix

else
   nix-shell -p git --command "git -C nixos pull"

fi

sed "s/host/$2/" build-qcow2.nix > build.nix
GC_DONT_GC=1  nix-build '<nixpkgs/nixos>' -A config.system.build.qcow2 -I nixos-config=./build.nix
