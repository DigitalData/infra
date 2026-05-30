USER="$(whoami)"
HOSTNAME="$(hostname)"

echo "Changing ownership of /etc/nixos to $USER..."
sudo chown -R "$USER" /etc/nixos
cd /etc/nixos

# git authentication
echo "Authenticating git access to GitHub..."
sh /etc/nixos/scripts/config/git-authenticate.sh

# remap origin to use ssh
echo "Changing git remote URL to use SSH..."
git remote set-url origin git@github.com:DigitalData/infra.git

# add the updated hardware configuration
echo "Adding updated hardware configuration to git..."
git add hosts/*/hardware-configuration.nix
git commit -m "$HOSTNAME / Hardware Configuration"
git push

# pull latest changes
echo "Pulling latest changes from GitHub..."
git fetch origin
git pull