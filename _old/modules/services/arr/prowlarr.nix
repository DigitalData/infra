{ config, pkgs, ... }:

{
  # Prowlarr indexer aggregator
  # TODO: Configure prowlarr service, port, indexer integrations
  services.prowlarr.enable = false;
}
