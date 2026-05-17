
USER="$(whoami)"

# if not exists, generate SSH key for git authentication
if [ ! -f ~/.ssh/id_ed25519_git ]; then
  echo "Generating git SSH Key for ${USER}@${HOSTNAME}"
  ssh-keygen -t ed25519 -C "${USER}@${HOSTNAME}" -f ~/.ssh/id_ed25519_git
  echo "Please add the following public SSH key to git with write access:"
  cat ~/.ssh/id_ed25519_git.pub
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_git
