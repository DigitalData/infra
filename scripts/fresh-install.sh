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

# if the path exists, no need to clone.
if [ ! -e "~/infra" ]; then
  echo "Cloning infra repository to /etc/nixos for installation..."
  git clone https://github.com/DigitalData/infra.git ~/infra
fi

echo "Running disko to destroy and format disk for new host..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake "~/infra/$HOST_FOLDER"

echo "Disk disko complete. Now generating NixOS configuration for new host..."
sudo nixos-generate-config --no-filesystems --root /mnt

echo "Generating NixOS configuration complete. Now copying hardware configuration to infra..."
sudo cp -r /mnt/etc/nixos/hardware-configuration.nix ~/infra/$HOST_FOLDER/

echo "Disk disko complete. Now installing NixOS to disk..."
sudo nixos-install --root /mnt --no-root-passwd --flake "~/infra/$HOST_FOLDER"

echo "Disk installation complete. Now setting root password for new host..."
sudo nixos-enter --root /mnt -c 'passwd digitaldata'