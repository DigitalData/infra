
USER="$(whoami)"
CURRENT_DIR="$(realpath .)"

# if not exists, generate SSH key for git authentication
if [ ! -f ~/.ssh/id_ed25519_git_config ]; then
    echo "Generating git SSH Key for ${USER}@${HOSTNAME}:"
    ssh-keygen -t ed25519 -C "${USER}@${HOSTNAME}" -f ~/.ssh/id_ed25519_git_config
    echo "Please add the following public SSH key to git with write access:"
    cat ~/.ssh/id_ed25519_git_config.pub
fi

# if agent not running, start it and add the SSH key
if ! pgrep -x "ssh-agent" > /dev/null; then
    echo "Starting ssh-agent and adding SSH key for git authentication:"
    cd ~
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519_git_config
else
    echo "ssh-agent is already running, adding SSH key for git authentication:"
    ssh-add -L | grep -f ~/.ssh/id_ed25519_git_config.pub || ssh-add ~/.ssh/id_ed25519_git_config
fi

# if infra repo exists, update git remote URL to use SSH instead of HTTPS
if [ "$(git remote get-url origin)" != "git@github.com:DigitalData/infra.git" ]; then
    echo "Updating git remote URL to use SSH instead of HTTPS:"
    cd "/etc/nixos"
    git remote set-url origin "git@github.com:DigitalData/infra.git"
fi

cd "$CURRENT_DIR"