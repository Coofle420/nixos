{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
  ];

  programs.fish = {
    enable = true;

    plugins = [
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
    ];

    shellAbbrs = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Git
      gs = "git status -sb";
      gd = "git diff";
      gc = "git commit";
      gl = "git log --oneline --graph --decorate -20";
      gp = "git push";
      gpl = "git pull";

      # Nix
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos";

      ff = "fastfetch";
    };

    # Aliases stay short on the command line, unlike abbreviations.
    shellAliases = {
      ls = "eza --group-directories-first";
      ll = "eza -l --group-directories-first";
      la = "eza -la --group-directories-first";
      lt = "eza --tree --level=2 --group-directories-first";
      cat = "bat";
      grep = "rg";
      find = "fd";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""

      # Show fastfetch once per terminal. Remove to stop it.
      if not set -q FASTFETCH_SHOWN
        set -gx FASTFETCH_SHOWN 1
        fastfetch
      end
    '';

    functions = {
      hme = {
        description = "Edit the NixOS + Home Manager config";
        body = ''
          set -l editor $EDITOR
          test -z "$editor"; and set editor nano
          $editor /etc/nixos/home/home.nix
        '';
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1000;
      palette = "catppuccin_mocha";
      format = "$username$hostname$directory$nix_shell$git_branch$git_status$git_state$git_metrics$nodejs$rust$python$golang$lua$package$fill$cmd_duration$jobs$time\n$status$character";

      directory = {
        style = "bold blue";
        truncation_length = 4;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      git_branch = {
        style = "bold mauve";
        symbol = " ";
        format = "[$symbol$branch]($style) ";
      };
      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style) )";
      };
      git_state.style = "bold yellow";
      git_metrics = {
        disabled = false;
        added_style = "bold green";
        deleted_style = "bold red";
        format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
      };

      # Nix logo -- shows whenever you're in a nix-shell / nix develop session.
      nix_shell = {
        symbol = " ";
        style = "bold sapphire";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      # Language/toolchain badges -- only appear in a matching project dir.
      nodejs = { symbol = " "; style = "bold green"; format = "[$symbol$version]($style) "; };
      rust = { symbol = "󱘗 "; style = "bold peach"; format = "[$symbol$version]($style) "; };
      python = { symbol = " "; style = "bold yellow"; format = "[$symbol$version]($style) "; };
      golang = { symbol = " "; style = "bold sky"; format = "[$symbol$version]($style) "; };
      lua = { symbol = " "; style = "bold blue"; format = "[$symbol$version]($style) "; };
      package = { symbol = "󰏗 "; style = "bold teal"; format = "[$symbol$version]($style) "; };

      # Exit code of the last command, only shown on failure.
      status = {
        symbol = " ";
        style = "bold red";
        format = "[$symbol$status]($style) ";
        disabled = false;
      };

      username = {
        style_user = "bold sapphire";
        format = "[$user]($style)@";
      };
      hostname = {
        ssh_only = true;
        ssh_symbol = " ";
        style = "bold sapphire";
        format = "[$ssh_symbol$hostname]($style) ";
      };

      cmd_duration = {
        min_time = 500;
        style = "bold yellow";
        format = "[$duration]($style) ";
      };
      time = {
        disabled = false;
        time_format = "%H:%M";
        style = "bold overlay0";
        format = "[$time]($style) ";
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      # Plain gap instead of starship's default dotted leader.
      fill.symbol = " ";

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  programs.eza.enable = true;
  programs.bat.enable = true;
}
