return {
  {
    "conform.nvim",
    event = "DeferredUIEnter",
    after = function ()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          bash = { "shfmt" },
          nix = { "nixfmt" },
          rust = { "rustfmt" },
          typst = { "typstyle" },
          python = { "ruff" },
          -- otter = { "ruff", lsp_format = "prefer" },
          ts = { "prettier" },
          tsx = { "prettier" },
          cs = { "csharpier" },
        },

        formatters = {
          ruff = {
            command = "ruff",
            args = { "format", "-" },
          },
        },
      })

      vim.keymap.set({ "n" }, "<leader>lf", function ()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format Buffer" })
    end,
  },
}
