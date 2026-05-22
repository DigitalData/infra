set -e
if [ -z "$1" ]; then
  echo "Usage: $0 /hosts/<hostname>"
  exit 1
fi
HOST_FOLDER="$1"
if [ ! -d "$HOST_FOLDER" ]; then
  echo "Error: $HOST_FOLDER is not a directory"
  exit 1
fi

nix run github:nix-community/disko -- --mode disko --flake "/etc/nixos/$HOST_FOLDER"
nixos-install --flake "/etc/nixos/$HOST_FOLDER"