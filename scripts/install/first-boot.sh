USER="$(whoami)"

echo "Copying /etc/nixos to ~/infra for git management..."
cp -r /etc/nixos ~/infra

echo "Clear /etc/nixos"
sudo rm -rf /etc/nixos/*

echo "Creating symlink from ~/infra to /etc/nixos..."
sudo ln -s ~/infra /etc/nixos

echo "Initial authentication with git to GitHub..."
sh /etc/nixos/scripts/config/git-authenticate.sh

# add the updated hardware configuration
echo "Adding updated hardware configuration to git..."
cd /etc/nixos
git add hardware-configuration.nix
git commit -m "$(hostname) / Hardware Configuration"
git push

# pull latest changes
echo "Pulling latest changes from GitHub..."
git fetch origin
git pull

echo "First boot configuration complete."
echo "Please encapsulate the hardware configuration in a dendritic modules (refer to octantis)."
# TODO: Automate the above.