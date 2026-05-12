# Given the host's pathname, run the disko script
# Usage: `./disko.sh /path/to/host-module-folder`
# Example: `./disko.sh hosts/octantis`
#!/usr/bin/env bash
set -e
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/host-module-folder"
  exit 1
fi
HOST_FOLDER="$1"
if [ ! -d "$HOST_FOLDER" ]; then
  echo "Error: $HOST_FOLDER is not a directory"
  exit 1
fi
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount "$HOST_FOLDER/disko.nix"
