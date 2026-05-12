# Quickstart Guide

Get your nixos-config running on a new host.

## Part 1: Build a New Host Configuration

### Step 1: Copy the host template

Choose your platform:

**For NixOS (Linux servers/desktops):**
```bash
cd nixos-config
cp -r hosts/octantis hosts/my-nixos-host
```

**For macOS (with nix-darwin):**
```bash
cd nixos-config
cp -r hosts/darwin-mac hosts/my-darwin-host
```

### Step 2: Customize the configuration

#### For NixOS hosts:

Edit `hosts/my-nixos-host/flake.nix`:
```nix
nixosConfigurations.my-nixos-host = nixpkgs.lib.nixosSystem {
  inherit system;
  # ... rest of config
};
```

Edit `hosts/my-nixos-host/configuration.nix`:
```nix
{
  networking.hostName = "my-nixos-host";  # Change hostname
  time.timeZone = "Your/Timezone";        # Set timezone
  
  users.users.username = {                # Add your user
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
```

#### For darwin hosts:

Edit `hosts/my-darwin-host/flake.nix`:
```nix
darwinConfigurations."my-darwin-host" = nix-darwin.lib.darwinSystem {
  # ... update system arch as needed (aarch64-darwin for M1/M2, x86_64-darwin for Intel)
};
```

Edit `hosts/my-darwin-host/configuration.nix`:
```nix
{
  system.defaults.dock.autohide = true;
  # ... customize macOS settings
}
```

### Step 3: Customize home-manager

Edit `hosts/my-host/home-configuration.nix`:
```nix
{
  home.username = "your-username";
  home.homeDirectory = "/home/your-username"; # or /Users/your-username on macOS
  
  home.packages = with pkgs; [
    # Add your tools here
  ];
}
```

---

## Part 1.5: Install NixOS Directly from Installer USB

Skip the manual installation and go straight to your configured system:

### Step 1: Boot into NixOS installer

1. Download the latest NixOS ISO
2. Create a bootable USB drive
3. Boot from the USB drive
4. Select "NixOS installer" from the GRUB menu

### Step 2: Set up networking and git

```bash
# Connect to WiFi (if needed)
sudo systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "YOUR_WIFI_SSID"
> set_network 0 psk "YOUR_WIFI_PASSWORD"
> enable_network 0
> quit

# Test internet connection
ping -c 3 google.com

# Install git and generate SSH key
sudo nix-env -iA nixos.git
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github -C "installer@my-nixos-host"

# Add the public key to GitHub (SSH Keys in settings)
cat ~/.ssh/id_ed25519_github.pub
```

### Step 3: Clone your config repo

```bash
# Clone via SSH (recommended)
git clone git@github.com:YOUR-USERNAME/YOUR-REPO.git /mnt/nixos-config

# Or via HTTPS (less secure)
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git /mnt/nixos-config
```

### Step 4: Identify your disks

```bash
# List available disks by ID (persistent identifiers)
ls /dev/disk/by-id/

# Note the disk IDs you'll use in your disko config
# Example output:
# ata-ST2000DM001-1CH164_Z1E3253L
# ata-Corsair_Neutron_GTX_SSD_130479140000971401BB
```
Use this to update the `disko.nix` for the new host.

### Step 5: Partition and format disks with disko

Instead of manual partitioning, use disko for declarative disk management:

```bash
# Run disko to partition and format
sudo sh ./scripts/disko.sh /hosts/<hostname>
```

> [!NOTE]
> You may see "can't read superblock" messages during the destroy phase - this is normal and expected when wiping existing partitions. Disko will continue and complete successfully.

### Step 5: Generate hardware config and install

```bash
# Generate hardware configuration
sudo nixos-generate-config --root /mnt

# Copy your host config to the mounted system
sudo cp -r /mnt/nixos-config/hosts/my-nixos-host/* /mnt/etc/nixos/

# Install NixOS using your flake
sudo nixos-install --flake /mnt/etc/nixos#my-nixos-host

# Set root password when prompted
sudo nixos-enter -c 'passwd'

# Reboot into your new system
sudo reboot
```

### Step 6: Post-install setup

After reboot, your system should be running with your configuration. Complete the SSH setup:

```bash
# On your development machine, get your SSH public key
cat ~/.ssh/id_ed25519.pub

# On the new NixOS host, add it to the digitaldata user
sudo -u digitaldata mkdir -p /home/digitaldata/.ssh
sudo -u digitaldata chmod 700 /home/digitaldata/.ssh
echo "YOUR_PUBLIC_KEY_HERE" | sudo -u digitaldata tee /home/digitaldata/.ssh/authorized_keys
sudo -u digitaldata chmod 600 /home/digitaldata/.ssh/authorized_keys
sudo chown -R digitaldata:users /home/digitaldata/.ssh
```

Now you can SSH in without a password!

---

## Part 2: Set Up the New Host to Use This Config

### For NixOS (first-time install)

#### Step 1: Install NixOS

1. Boot into NixOS installer
2. Follow installer prompts (partition disks, create user, etc.)
3. During installation, when prompted for configuration, you can use defaults

#### Step 2: Generate hardware configuration

After first boot, generate your hardware config:

```bash
sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

Copy this to your repo:
```bash
# On your development machine:
scp root@my-nixos-host:/tmp/hardware-configuration.nix hosts/my-nixos-host/
```

Or manually copy the output into `hosts/my-nixos-host/hardware-configuration.nix`.

#### Step 3: Clone the repo with SSH

On the new NixOS host:

```bash
# Generate SSH key for git (if you don't have one)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github -C "my-nixos-host"

# Add the public key to GitHub (SSH Keys in settings)
cat ~/.ssh/id_ed25519_github.pub

# Clone the config repo via SSH (no password needed for future pulls)
git clone git@github.com:YOUR-USERNAME/YOUR-REPO.git /etc/nixos
cd /etc/nixos
```

This way, future `git pull` commands won't require authentication.

#### Step 4: Set up SSH access from your development machine

To SSH into your host without passwords, add your development machine's SSH key:

**On your development machine:**
```bash
# Copy your public key (or generate a new host-specific key)
cat ~/.ssh/id_ed25519.pub  # or id_rsa.pub

# Or create a host-specific key for this server:
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_my-nixos-host -C "dev-machine-to-my-nixos-host"
cat ~/.ssh/id_ed25519_my-nixos-host.pub
```

**On the NixOS host:**
```bash
# Create authorized_keys file if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add your development machine's public key to authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... dev-machine-to-my-nixos-host" >> ~/.ssh/authorized_keys

# Or use ssh-copy-id from your dev machine:
# ssh-copy-id -i ~/.ssh/id_ed25519_my-nixos-host.pub user@my-nixos-host
```

**Test SSH access:**
```bash
# From your development machine
ssh user@my-nixos-host  # Should connect without password
```

#### Step 5: First flake rebuild

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#my-nixos-host
```

If successful, your system now uses the flake configuration.

---

### For macOS (with nix-darwin)

#### Step 1: Install Nix

```bash
# Install Nix with flakes support
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
```

#### Step 2: Clone the repo with SSH

```bash
# Generate SSH key for git (if you don't have one)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github -C "my-darwin-host"

# Add the public key to GitHub (SSH Keys in settings)
cat ~/.ssh/id_ed25519_github.pub

# Clone the config repo via SSH (no password needed for future pulls)
git clone git@github.com:YOUR-USERNAME/YOUR-REPO.git ~/.config/nixpkgs
cd ~/.config/nixpkgs
```

This way, future `git pull` commands won't require authentication.

#### Step 3: Set up SSH access from your development machine

To SSH into your macOS host without passwords, add your development machine's SSH key:

**On your development machine:**
```bash
# Copy your public key (or generate a new host-specific key)
cat ~/.ssh/id_ed25519.pub  # or id_rsa.pub

# Or create a host-specific key for this mac:
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_my-darwin-host -C "dev-machine-to-my-darwin-host"
cat ~/.ssh/id_ed25519_my-darwin-host.pub
```

**On the macOS host:**
```bash
# Create authorized_keys file if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add your development machine's public key to authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... dev-machine-to-my-darwin-host" >> ~/.ssh/authorized_keys

# Or use ssh-copy-id from your dev machine:
# ssh-copy-id -i ~/.ssh/id_ed25519_my-darwin-host.pub user@my-darwin-host
```

**Test SSH access:**
```bash
# From your development machine
ssh user@my-darwin-host  # Should connect without password
```

#### Step 4: Build nix-darwin
git clone <your-repo-url> ~/nixos-config
cd ~/nixos-config/hosts/my-darwin-host

# Add host SSH key to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub
```

#### Step 3: First nix-darwin build and switch

```bash
cd ~/nixos-config/hosts/my-darwin-host

# Generate the flake inputs
nix flake update

# Build nix-darwin
nix run nix-darwin -- switch --flake .

# Link the configuration to system location (optional but useful)
# nix run nix-darwin -- switch --flake . --show-trace
```

After switching, future rebuilds:
```bash
darwin-rebuild switch --flake .
```

---

### For WSL2 / Lix (lightweight Nix alternative)

If using Lix instead of traditional Nix:

```bash
# Install Lix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh

# Follow the same steps as NixOS or darwin above
```

---

## Part 3: Post-Setup Steps

### Add SSH keys for secrets management

If you plan to use agenix for secrets (see [secrets.md](secrets.md)):

```bash
# On your new host
cat ~/.ssh/id_ed25519.pub

# Add this to shared/secrets/secrets.nix in your repo
# Re-encrypt existing secrets to include the new host's key
```

### Enable and configure services

Edit your host's `configuration.nix` to enable services:

```nix
{
  imports = [
    ../../modules/services/jellyfin
    ../../modules/services/homepage
    # ... other services
  ];

  services.jellyfin.enable = true;
  services.jellyfin.dataDir = "/mnt/media";
}
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .  # NixOS
darwin-rebuild switch --flake .      # macOS
```

### Set up home-manager (NixOS only - standalone)

If using home-manager standalone:

```bash
home-manager switch --flake .#username@hostname
```

---

## Troubleshooting

**Flake won't evaluate:**
```bash
nix flake check
```

**Missing nixpkgs:**
```bash
nix flake update
```

**SSH key not found during rebuild:**
```bash
ssh-add ~/.ssh/id_ed25519
```

**Home-manager conflicts with existing files:**
```bash
home-manager switch --flake . -b backup
```

See [docs/secrets.md](secrets.md) for secrets-specific setup.
See [docs/modules.md](modules.md) for using and creating modules.
