require("lze").load({
  {
    "nvim-lspconfig",
    on_require = { "lspconfig" },
    lsp = function (plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function (_)
      vim.lsp.config("*", {
        on_attach = require("LSPs.on_attach"),
      })
    end,
  },
  {
    "lazydev.nvim",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function ()
      require("lazydev").setup({
        library = {
          {
            words = { "nixInfo%.lze" },
            path = nixInfo("lze", "plugins", "start", "lze") .. "/lua",
          },
          {
            words = { "nixInfo%.lze" },
            path = nixInfo("lzextras", "plugins", "start", "lzextras") .. "/lua",
          },
          { words = { "Snacks" }, path = "snacks.nvim" },
        },
      })
    end,
  },
  {
    "ruff",
    cat = "full",
    lsp = {},
  },
  {
    "ty",
    cat = "full",
    lsp = {},
  },
  {
    "sqls",
    cat = "full",
    lsp = {},
  },
  {
    "gopls",
    cat = "full",
    lsp = {},
  },
  {
    "zls",
    cat = "full",
    lsp = {},
  },
  {
    "lua_ls",
    cat = "minimal",
    lsp = {
      filetypes = { "lua" },
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnositcs = {
            globals = { "nixInfo", "vim" },
            disable = { "missing-fields" },
          },
          telemetry = { enabled = false },
        },
      },
    },
  },
  {
    "nixd",
    enabled = nixInfo.isNix,
    cat = "nix",
    lsp = {
      filetypes = { "nix" },
      settings = {
        nixd = {
          nixpkgs = {
            expr = [[import <nixpkgs> {}]],
          },
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    },
  },
  {
    "tinymist",
    cat = "full",
    lsp = {
      on_attach = require("LSPs.on_attach"),
    },
  },
  {
    "clangd",
    cat = "full",
    lsp = {
      on_attach = require("LSPs.on_attach"),
    },
  },
  {
    "lemminx",
    cat = "full",
    lsp = {},
  },
  {
    "yamlls",
    cat = "minimal",
    lsp = {},
  },
  {
    "rust_analyzer",
    cat = "full",
    lsp = {
      on_attach = require("LSPs.on_attach"),
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            targetDir = true,
            allTargets = false,
          },
        },
      },
    },
  },
  {
    "glsl_analyzer",
    cat = "full",
    lsp = {
      filetypes = { "html" },
    },
  },
  {
    "tombi",
    cat = "minimal",
    lsp = {},
  },
  {
    "crates.nvim",
    cat = "full",
    event = "BufRead Cargo.toml",
    after = function ()
      local crates = require("crates")
      crates.setup({
        lsp = {
          enabled = true,
          on_attach = function (client, bufnr)
            require("LSPs.on_attach")()
          end,
          actions = true,
          completion = true,
          hover = true,
        },
      })
      vim.keymap.set("n", "<leader>cf", function ()
        crates.show_features_popup()
        crates.focus_popup()
      end, { silent = true, desc = "Features Popup" })
      vim.keymap.set("n", "<leader>cv", function ()
        crates.show_versions_popup()
        crates.focus_popup()
      end, { silent = true, desc = "Versions Popup" })
      vim.keymap.set("n", "<leader>cd", function ()
        crates.show_dependencies_popup()
        crates.focus_popup()
      end, { silent = true, desc = "Dependencies Popup" })
      vim.keymap.set("n", "<leader>cu", function ()
        crates.upgrade_crate()
      end, { silent = true, desc = "Upgrade Crate" })
      vim.keymap.set("n", "<leader>cU", function ()
        crates.upgrade_all_crates()
      end, { silent = true, desc = "Upgrade All Crates" })
      require("which-key").add({
        { "<leader>c", group = "Crates" },
      })
    end,
  },
  {
    "marksman",
    cat = "full",
    lsp = {},
  },
  {
    "ts_ls",
    cat = "full",
    lsp = {},
  },
  {
    "bashls",
    cat = "minimal",
    lsp = {},
  },
  {
    "cssls",
    cat = "minimal",
    lsp = {},
  },
  {
    "jsonls",
    cat = "minimal",
    lsp = {},
  },
  {
    "nvim-jdtls",
    cat = "full",
  },
  {
    "roslyn_ls",
    cat = "full",
    ft = "cs",
    lsp = {
      filetypes = { "cs" },
      cmd = { "Microsoft.CodeAnalysis.LanguageServer", "--stdio" },
      on_attach = require("LSPs.on_attach"),
    },
  },
})

if nixInfo.cat("full") then
  local jdtls = require("jdtls")
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function ()
      local config = {
        cmd = { "jdtls" },
        root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw", "pom.xml" }),
        settings = {
          java = {
            contentProvider = { preferred = "cfr" },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            import = {
              maven = {
                enabled = true,
              },
              gradle = {
                enabled = true,
                wrapper = {
                  enabled = true,
                },
              },
            },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-1.8",
                  path = nixCats.extra["jdk8-path"],
                },
                {
                  name = "JavaSE-21",
                  path = "/run/current-system/sw/lib/openjdk",
                },
              },
            },
          },
        },
        init_options = {
          bundles = {
            "/home/indi/Development/Java/vscode-java-decompiler/server/dg.jdt.ls.decompiler.cfr-0.0.3.jar",
            "/home/indi/Development/Java/vscode-java-decompiler/server/dg.jdt.ls.decompiler.common-0.0.3.jar",
            "/home/indi/Development/Java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.2.jar",
          },
          extendedClientCapabilities = jdtls.extendedClientCapabilities,
        },
        on_attach = function ()
          require("LSPs.on_attach")()
          -- jdtls.setup_dap()
        end,
      }
      jdtls.start_or_attach(config)
    end,
  })
end
