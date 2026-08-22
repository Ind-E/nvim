inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  options,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];
  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };

  config.settings.dont_link = config.binName != "nvim";

  config.binName = lib.mkDefault "nvim";
  config.settings.aliases = [
    "v"
    "vim"
  ];

  config.specs = {
    nix = {
      after = [ "minimal" ];
      data = null;
      runtimePkgs = with pkgs; [
        nixd
        nixfmt
        statix
      ];
    };

    lua = {
      after = [ "minimal" ];
      lazy = true;
      data = with pkgs.vimPlugins; [
        lazydev-nvim
      ];
      runtimePkgs = with pkgs; [
        lua-language-server
        stylua
      ];
    };

    kitty = {
      lazy = false;
      enable = lib.mkDefault false;
      data = [ pkgs.vimPlugins.kitty-scrollback-nvim ];
    };

    core = {
      lazy = false;
      data = with pkgs.vimPlugins; [
        vscode-nvim
        nvim-web-devicons

        config.nvim-lib.neovimPlugins.lze
        {
          data = config.nvim-lib.neovimPlugins.lzextras;
          name = "lzextras";
        }
      ];
    };

    minimal-startup = {
      after = [ "core" ];
      lazy = false;
      data = with pkgs.vimPlugins; [
        vim-textobj-entire
        bufferline-nvim
        nvim-colorizer-lua
        nvim-cmp
      ];

    };

    minimal = {
      after = [ "core" ];
      lazy = true;
      data = with pkgs.vimPlugins; [
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

        config.nvim-lib.neovimPlugins.chezmoi-nvim
        plenary-nvim
      ];
      runtimePkgs = with pkgs; [
        tree-sitter
        universal-ctags

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

        easy-dotnet-nvim
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
      ];
    };

  };

  options.settings.kitty = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config.env.DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";

  config.specMods =
    {
      name,
      parentName,
      parentSpec,
      ...
    }:
    {
      options.runtimePkgs = options.runtimePkgs // {
        description = ''
          A runtimePkgs spec field to put packages on the PATH
          If the spec is disabled, this value will not be included in the resulting neovim derivation
        '';
      };

      config = lib.mkIf config.settings.kitty {
        enable =
          if parentName == null then
            (if (name == "kitty" || name == "core") then true else false)
          else
            parentSpec.enable;
      };
    };

  config.runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];

  # Inform our lua of which top level specs are enabled
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };

  # build plugins from inputs set
  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
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
}
