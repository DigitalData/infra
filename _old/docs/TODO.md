# TODO

Infrastructure and configuration tasks for the nixos-config project.

## Immediate Priorities

- [ ] **Secrets Setup**
  - [ ] Create `shared/secrets/secrets.nix` with SSH public keys for agenix
  - [ ] Document key rotation and multi-user secrets encryption
  - [ ] Test agenix encryption/decryption workflow on octantis

- [ ] **Octantis Services (Dendritic Branches)**
  - [ ] Fill in `modules/services/jellyfin/default.nix` with production config
  - [ ] Fill in `modules/services/homepage/default.nix` with dashboard setup
  - [ ] Fill in `modules/services/immich/default.nix` with photo backup config
  - [ ] Fill in `modules/services/nextcloud/default.nix` with file sync setup
  - [ ] Fill in `modules/services/arr/` modules:
    - [ ] sonarr.nix
    - [ ] radarr.nix
    - [ ] prowlarr.nix
    - [ ] bazarr.nix
    - [ ] jellyseer.nix
    - [ ] lidarr.nix
  - [ ] Set up networking (reverse proxy, domain, SSL certificates)
  - [ ] Configure storage mounts for media/backups

- [ ] **Home-Manager Integration**
  - [ ] Expand `hosts/octantis/home-configuration.nix` with xavtrav user dotfiles
  - [ ] Add shell aliases, functions, development tools
  - [ ] Configure neovim, git hooks, SSH agent

- [ ] **Testing & Deployment**
  - [ ] Test octantis rebuild with flake: `cd hosts/octantis && sudo nixos-rebuild switch --flake .`
  - [ ] Verify all services start correctly after rebuild
  - [ ] Document any post-rebuild manual setup steps

## Darwin / Mac Setup (Future)

- [ ] Finalize `hosts/darwin-mac/` configuration
  - [ ] Test nix-darwin flake structure
  - [ ] Add ghostty configuration in `modules/desktop/ghostty.nix`
  - [ ] Add amethyst window manager setup in `modules/desktop/amethyst.nix`
  - [ ] Add VS Code configuration in `modules/desktop/vscode.nix`
  - [ ] Configure home-manager for macOS user

- [ ] Test Mac deployment workflow

## Documentation & CI/CD

- [ ] Add GitHub Actions / CI pipeline to validate all flakes on push
- [ ] Document troubleshooting procedures
- [ ] Create video/walkthrough for adding a new host

## Long-term Goals

- [ ] Multi-user secrets management with agenix
- [ ] Automated backups from octantis to external storage
- [ ] Monitoring and alerting setup (Prometheus, Grafana)
- [ ] Container support (Docker/Podman) for additional services
- [ ] Distributed storage (Syncthing, Ceph) across multiple hosts
