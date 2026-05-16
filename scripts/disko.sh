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

echo "Running disko for host folder: $HOST_FOLDER"
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy "$HOST_FOLDER/disko.nix"

echo "Disk destroyed and formatted. Now mounting..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode format,mount "$HOST_FOLDER/disko.nix"