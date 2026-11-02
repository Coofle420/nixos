{
  description = "nixos system + home-manager: cachyos kernel, umbriel + noctalia desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    umbriel.url = "github:noctalia-dev/umbriel";
    noctalia.url = "github:noctalia-dev/noctalia-shell";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Third-party, not in nixpkgs: packages the official imputnet/helium-linux
    # .deb release (hash-pinned), no build-from-source, no install scripts run.
    helium.url = "github:oxcl/nix-flake-helium-browser";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    # Third-party, not in nixpkgs: repackages Anthropic's own official Linux
    # .deb (downloads.claude.ai, hash-pinned), no install scripts run.
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";

    # Third-party, not in nixpkgs: native Rust (egui) Spotify client.
    spotifast.url = "github:crmne/spotifast";
    spotifast.inputs.nixpkgs.follows = "nixpkgs";

    # Third-party, not in nixpkgs: terminal Spotify client (TUI).
    spotatui.url = "github:LargeModGames/spotatui";
    spotatui.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      chaotic,
      umbriel,
      noctalia,
      home-manager,
      nix-flatpak,
      helium,
      claude-desktop,
      spotifast,
      spotatui,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          chaotic.nixosModules.default
          umbriel.nixosModules.default
          noctalia.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";

            home-manager.extraSpecialArgs = {
              claudeDesktopPackage = claude-desktop.packages.x86_64-linux.claude-desktop;
              spotifastPackage = spotifast.packages.x86_64-linux.default;
              spotatuiPackage = spotatui.packages.x86_64-linux.default;
            };

            home-manager.sharedModules = [
              umbriel.homeModules.default
              noctalia.homeModules.default
              nix-flatpak.homeManagerModules.nix-flatpak
              helium.homeModules.default
            ];

            home-manager.users.user = import ./home/home.nix;
          }
        ];
      };
    };
}
