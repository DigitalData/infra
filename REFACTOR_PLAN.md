# Monolithic Flake Refactor Plan

Goal: Consolidate `hosts/*/flake.nix` into a single root `flake.nix` for centralized configuration management.

## Current State
```
hosts/
  octantis/
    flake.nix (standalone)
    configuration.nix
    home-configuration.nix
    hardware-configuration.nix
  darwin-mac/
    flake.nix (standalone)
    configuration.nix
    home-configuration.nix
modules/
  common/
  shells/
  users/
  desktop/
  services/
```

## Target State
```
flake.nix (ROOT - centralized)
hosts/
  octantis/
    configuration.nix
    home-configuration.nix
    hardware-configuration.nix
  darwin-mac/
    configuration.nix
    home-configuration.nix
    (no flake.nix)
modules/
  (unchanged)
```

## Steps to Refactor

### Phase 1: Create Root Flake
- [ ] **Step 1**: Create `/flake.nix` at repo root
  - Consolidate all inputs (nixpkgs, home-manager, nix-darwin, agenix)
  - Define outputs for `nixosConfigurations.octantis`
  - Define outputs for `darwinConfigurations.darwin-mac`
  - Define outputs for `homeConfigurations` for both hosts
  - Include helper functions to reduce duplication

### Phase 2: Update Rebuild Alias
- [ ] **Step 2**: Update `modules/shells/bash.nix`
  - Change flake path from relative (`.`) to root (`/`)
  - Update flake references: `.#octantis` and `.#darwin-mac`
  - Command becomes: `cd / && nixos-rebuild switch --flake .#octantis`

### Phase 3: Remove Old Flakes
- [ ] **Step 3**: Delete old flake files
  - Delete `hosts/octantis/flake.nix`
  - Delete `hosts/darwin-mac/flake.nix`
  - Git cleanup (flake.lock at root, not per-host)

### Phase 4: Update Rebuild Commands
- [ ] **Step 4**: Test new rebuild workflow
  - Octantis: `cd /path/to/repo && nixos-rebuild switch --flake .#octantis`
  - Darwin: `cd /path/to/repo && darwin-rebuild switch --flake .#darwin-mac`
  - Verify flake path in rebuild alias works correctly

### Phase 5: Testing
- [ ] **Step 5**: Validate both host configs
  - Run `nix flake check` at root
  - Test `nix build .#nixosConfigurations.octantis.system`
  - Test `nix build .#darwinConfigurations.darwin-mac.system`

## New Rebuild Workflow

**Before:**
```bash
cd hosts/octantis
nixos-rebuild switch --flake .

cd hosts/darwin-mac
darwin-rebuild switch --flake .
```

**After:**
```bash
# From anywhere, with alias
rebuild  # auto-cds and uses correct flake
```

## Future Benefits
- ✅ Single input management (no duplicate nixpkgs, home-manager, etc)
- ✅ Easy to add new hosts (just add to root flake outputs)
- ✅ Centralized configuration discovery
- ✅ Reusable modules across all hosts
- ✅ Ready for `flake-parts` migration if needed later

## Notes
- **Flake lock files**: Remove per-host `flake.lock`, keep only root `flake.lock`
- **Home-manager integration**: Verify octantis standalone home-manager still works (may need to reference root flake)
- **Rebuild error on octantis**: Current per-host setup may have failing rebuild - this refactor should clarify if it's a flake path issue
