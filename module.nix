inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  options,
  ...
}:
let
  profiles = {
    kitty = [
      "core"
      "kitty"
    ];
    minimal = [
      "core"
      "minimal"
    ];
    full = [
      "core"
      "minimal"
      "full"
    ];
  };
in
{
  imports = [ wlib.wrapperModules.neovim ];
  options = {
    settings.profile = lib.mkOption {
      type = lib.types.enum (builtins.attrNames profiles);
      default = "full";
    };

    settings.cats = lib.mkOption {
      readOnly = true;
      type = lib.types.attrsOf lib.types.bool;
      default = builtins.mapAttrs (_: v: v.enable) config.specs;
    };

    extraPlugins = lib.mkOption {
      readOnly = true;
      type = lib.types.attrsOf wlib.types.stringable;
      default = config.pluginsFromPrefix "plugins-" inputs;
    };

    pluginsFromPrefix = lib.mkOption {
      type = lib.types.raw;
      readOnly = true;
      default =
        prefix: inputs:
        lib.pipe inputs [
          builtins.attrNames
          (builtins.filter (s: lib.hasPrefix prefix s))
          (map (
            input:
            let
              name = lib.removePrefix prefix input;
            in
            {
              inherit name;
              value = config.nvim-lib.mkPlugin name inputs.${input};
            }
          ))
          builtins.listToAttrs
        ];
    };
  };

  config = {
    binName = lib.mkDefault "nvim";
    settings.aliases = [
      "v"
      "vim"
    ];
    settings.dont_link = config.binName != "nvim";

    specs = {
      core = {
        name = "core";
        lazy = false;
        data = with pkgs.vimPlugins; [
          vscode-nvim
          nvim-web-devicons

          vim-textobj-entire
          bufferline-nvim
          nvim-colorizer-lua
          nvim-cmp

          config.extraPlugins.lze
          {
            data = config.extraPlugins.lzextras;
            name = "lzextras";
          }
        ];
      };

      kitty = {
        name = "kitty";
        after = [ "core" ];
        lazy = false;
        data = [ pkgs.vimPlugins.kitty-scrollback-nvim ];
      };

      minimal = {
        name = "minimal";
        after = [ "core" ];
        lazy = true;
        data = with pkgs.vimPlugins; [
          lazydev-nvim

          auto-save-nvim
          conform-nvim
          gitsigns-nvim
          lualine-nvim
          mini-ai
          mini-pairs
          mini-surround
          mini-trailspace
          mini-splitjoin
          lazydev-nvim
          nvim-lint
          nvim-lspconfig
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          quick-scope
          snacks-nvim
          which-key-nvim
          hop-nvim
          vim-sleuth
          ts-comments-nvim

          cmp-cmdline
          blink-cmp
          blink-compat
          colorful-menu-nvim

          config.extraPlugins.chezmoi-nvim
          plenary-nvim
        ];
        runtimePkgs = with pkgs; [
          tree-sitter
          universal-ctags

          nixd
          nixfmt
          statix

          lua-language-server
          stylua

          bash-language-server
          shellcheck
          shfmt

          tombi # toml
          vscode-langservers-extracted # css + json
          yaml-language-server
          yamllint
        ];
      };

      full = {
        name = "full";
        after = [ "minimal" ];
        lazy = true;
        data = with pkgs.vimPlugins; [
          crates-nvim

          mini-align

          markdown-preview-nvim
          nvim-dap
          nvim-dap-ui
          nvim-nio
          nvim-dap-virtual-text
          nvim-jdtls
          typst-preview-nvim
          vim-slime

          quarto-nvim
          otter-nvim
          image-nvim
          molten-nvim

          csvview-nvim

        ];
        runtimePkgs = with pkgs; [
          jdt-language-server # java ls
          jdk8
          clang-tools # c ls
          ty # python type checker
          ruff # python linter
          marksman # markdown ls
          typescript-language-server # typescript/javasrcipt ls
          prettier # ts fmt
          tinymist # typst ls
          websocat # for typst preview
          typstyle # typst fmt
          lemminx # xml ls
          glsl_analyzer # glsl ls
          sqls # sql ls
          gopls # go ls
          csharp-ls # csharp ls
          netcoredbg # chsarp dbg
          csharpier # csharp fmt
          roslyn-ls
        ];
      };
    };

    specMods = { name, parentName, ... }: {
      options.runtimePkgs = options.runtimePkgs;

      config = {
        enable = lib.mkIf (parentName == null) (
          lib.mkDefault (lib.elem name (profiles.${config.settings.profile} or [ ]))
        );
      };
    };

    runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];
  };
}
