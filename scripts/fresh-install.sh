set -e
if [ -z "$1" ]; then
  echo "Usage: $0 <hostname>"
  exit 1
fi

# if the path exists, no need to clone.
if [ ! -e "$HOME/infra" ]; then
  echo "Cloning infra repository to /etc/nixos for installation..."
  git clone https://github.com/DigitalData/infra.git "$HOME/infra"
fi

HOST_NAME="$1"
HOST_PATH="$HOME/infra/hosts/$HOST_NAME"
if [ ! -e "$HOST_PATH" ]; then
  echo "Error: $HOST_PATH is not a directory"
  exit 1
fi

echo "Running disko for host folder: $HOST_PATH"
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy "$HOST_PATH/disko.nix"

echo "Disk destroyed and formatted. Now mounting..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode format,mount "$HOST_PATH/disko.nix"

echo "Disk disko complete. Now generating NixOS configuration for new host..."
sudo nixos-generate-config --no-filesystems --root /mnt

echo "Generating NixOS configuration complete. Now copying hardware configuration to infra..."
sudo cp -r /mnt/etc/nixos/hardware-configuration.nix "$HOST_PATH/hardware-configuration.nix"

echo "Disk disko complete. Now installing NixOS to disk..."
sudo nixos-install --root /mnt --no-root-passwd --flake "$HOST_PATH#${HOST_NAME}"

echo "Disk installation complete. Now setting root password for new host..."
sudo nixos-enter --root /mnt -c 'passwd digitaldata'