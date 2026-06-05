# My Nix-based infrastructure as code.

One of the things I really enjoy about working in enterprise is that the configuration of a developer environment is often highly automated, reproducible, and documented. 
My personal dev environments are a mess. I have previously tried to organize a `dev/` directory structure repository in another repository, but this didn't play well with repositories within repositories and required me to create a bunch of symlinks to terminal shell configurations.

Hopefully using Nix and NixOS will allow me to trust my dev environment more.

## Goals
- [ ] Modularize reusable components.
- [ ] Octantis
  - [ ] Arr (Jellyfin, ...)
  - [ ] Immich + Nextcloud
  - [ ] Minecraft Servers (Modded, Vanilla)
  - [ ] Home Security (Cameras, Sensors, ...)
  - [ ] Home Assistant
- [ ] New hosts:
  - [ ] Draugr (Macbook Pro using `nix-darwin`)
  - [ ] Polaris (WSL2)

## Flake Input Dependencies (as of 2026-05-30)
*I will not keep track of individual services/packages used.*
- `nixpkgs`
- `flake-parts`
- `disko`
- `home-manager`

*I will not update this very frequently.*


## Useful Documentation
| Link | Description |
| --- | --- |
| [New Host Guide](./docs/new-host.md) | Instructions for adding a new host to this repository and initializing it. |
| [Glossary](./docs/glossary.md) | Definitions of key terms used in this repository. |

## Reference Articles
- [Vimjoyer](https://github.com/vimjoyer/nixconf)
- [Renato Garcia](https://renatogarcia.blog.br/posts/a-simple-nix-dendritic-config.html)
  - [Associated Reddit Post](https://old.reddit.com/r/NixOS/comments/1so8ymk/a_simple_nix_dendritic_config/)
- [Filip Ruman](https://filip-ruman.pages.dev/nixos_config/config_structure/)
- [Dendrix](https://dendrix.denful.dev)