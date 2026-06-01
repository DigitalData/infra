set -e
if [ -z "$1" ]; then
  echo "Usage: $0 <hostname>"
  exit 1
fi

# Clone the repository cleanly
rm -rf "/etc/nixos"
git clone https://github.com/DigitalData/infra.git /etc/nixos

HOST_NAME="$1"
HOST_PATH="/etc/nixos/hosts/$HOST_NAME"
if [ ! -e "$HOST_PATH" ]; then
  echo "Error: $HOST_PATH does not exist."
  exit 1
fi

ADMIN_USER="$2"
if [ -z "$ADMIN_USER" ]; then
  echo "Error: Specify an admin user (e.g. 'root' or 'digitaldata') as the second argument."
  exit 1
fi

if [ -f "$HOST_PATH/disks.nix" ]; then
  echo "Running disko for host folder: $HOST_PATH"
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy --flake .#$HOST_NAME

  echo "Disk destroyed and formatted. Now mounting..."
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode format,mount --flake .#$HOST_NAME

  echo "Disk disko complete. Now generating hardware configuration for new host..."
  sudo nixos-generate-config --no-filesystems --root /mnt --show-hardware-config > "$HOST_PATH/hardware-configuration.nix"
else
  echo "No disks.nix found for host. Skipping disko and generating hardware configuration."
  sudo nixos-generate-config --show-hardware-config > "$HOST_PATH/hardware-configuration.nix"
fi

echo "Generated hardware configuration. Now installing NixOS to disk..."
sudo nixos-install --root /mnt --no-root-passwd --flake "$HOST_PATH#$HOST_NAME"

echo "Disk installation complete. Now setting admin password for new host..."
sudo nixos-enter --root /mnt -c "sudo passwd $ADMIN_USER"

echo "Set ownership of /etc/nixos to $ADMIN_USER and exiting..."
sudo nixos-enter --root /mnt -c "sudo chown -R $ADMIN_USER /etc/nixos"