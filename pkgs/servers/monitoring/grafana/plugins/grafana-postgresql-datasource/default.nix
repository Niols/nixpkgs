{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-postgresql-datasource";
  version = "1.3.1";
  zipHash = {
    x86_64-linux = "sha256-Aa/15VPcRr37QL7ZN5VgTXqioqC9dWMODdigLJTPkr8=";
    aarch64-linux = "sha256-ASzyQkC+fHZVJPA3xBtfDD2i4rszlbu+gCMDbzZmlL0=";
    x86_64-darwin = "sha256-AKMDXsk+5cfohl7Dx4BwjjbPn3aXsQ4d917GmdBkwZI=";
    aarch64-darwin = "sha256-AWNkGZebMTMmoNtB7WevoWIEAYyOcba9PETaLwz8chI=";
  };
  meta = {
    description = "Visualize data from a PostgreSQL compatible database";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
  };
}
