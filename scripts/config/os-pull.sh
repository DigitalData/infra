CURRENT_DIR="$(realpath .)"

echo "Authenticating with git"
sh "/etc/nixos/scripts/config/git-authenticate.sh"

echo "Pulling latest OS configuration from git"
cd /etc/nixos
git fetch origin
git pull

cd "$CURRENT_DIR"