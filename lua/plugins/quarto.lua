return {
  {
    "image.nvim",
    ft = { "quarto" },
    after = function ()
      require("image").setup({
        backend = "kitty",
        kitty_method = "normal",
        integrations = {
          markdown = {
            filetypes = { "markdown", "quarto" },
          },
        },
        max_width = 200,
        max_height = 24,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
      })
    end,
  },
  {
    "molten-nvim",
    ft = { "quarto" },
    after = function ()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_auto_open_output = false
      vim.keymap.set(
        "n",
        "<localleader>mi",
        ":MoltenInit<CR>",
        { desc = "[i]nit", silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>me",
        ":MoltenEvaluateOperator<CR>",
        { desc = "[e]valuate operator", silent = true }
      )

      vim.keymap.set(
        "n",
        "<localleader>mo",
        ":noautocmd MoltenEnterOutput<CR>",
        { desc = "[o]pen output window", silent = true }
      )

      vim.keymap.set(
        "n",
        "<localleader>mr",
        ":MoltenReevaluateCell<CR>",
        { desc = "[r]e-eval cell", silent = true }
      )

      vim.keymap.set(
        "v",
        "<localleader>me",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { desc = "[e]xecute visual selection", silent = true }
      )

      vim.keymap.set(
        "n",
        "<localleader>mc",
        ":MoltenHideOutput<CR>",
        { desc = "[c]lose output window", silent = true }
      )

      vim.keymap.set(
        "n",
        "<localleader>md",
        ":MoltenDelete<CR>",
        { desc = "[d]elete Molten cell", silent = true }
      )
    end,
  },
  {
    "otter.nvim",
    dep_of = { "quarto-nvim" },
    ft = { "html" },
    after = function ()
      require("otter").setup({
        extensions = {
          glsl = "glsl",
        },
      })
      vim.keymap.set("n", "<leader>oa", function ()
        require("otter").activate({ "r", "python" })
      end, { desc = "otter activate (r/python)" })
      vim.keymap.set("n", "<leader>og", function ()
        require("otter").activate({ "glsl" }, true, true, nil)
      end, { desc = "otter activate (glsl)" })
      vim.keymap.set(
        "n",
        "<leader>od",
        require("otter").deactivate,
        { desc = "otter deactivate" }
      )
      require("LSPs.on_attach")()
    end,
  },
  -- {
  --   "quarto-nvim",
  --   ft = { "quarto", "markdown" },
  --   -- dep_of = { "molten-nvim" },
  --   after = function ()
  --     require("quarto").setup({
  --       lspFeatures = {
  --         enabled = true,
  --         languages = { "r", "python" },
  --         diagnostics = {
  --           enabled = true,
  --           triggers = { "BufWritePost" },
  --         },
  --         completion = {
  --           enabled = true,
  --         },
  --       },
  --       codeRunner = {
  --         default_method = "molten",
  --       },
  --     })
  --     vim.keymap.set(
  --       "n",
  --       "<localleader>Q",
  --       ":QuartoActivate<CR>",
  --       { desc = "quarto activate", silent = true }
  --     )
  --     local runner = require("quarto.runner")
  --     vim.keymap.set(
  --       "n",
  --       "<localleader>rc",
  --       runner.run_cell,
  --       { desc = "run [c]ell", silent = true }
  --     )
  --     vim.keymap.set(
  --       "n",
  --       "<localleader>ra",
  --       runner.run_above,
  --       { desc = "run cell and [a]bove", silent = true }
  --     )
  --     vim.keymap.set(
  --       "n",
  --       "<localleader>rA",
  --       runner.run_all,
  --       { desc = "run [A]ll cells", silent = true }
  --     )
  --     vim.keymap.set(
  --       "n",
  --       "<localleader>rl",
  --       runner.run_line,
  --       { desc = "run [l]ine", silent = true }
  --     )
  --     vim.keymap.set(
  --       "v",
  --       "<localleader>r",
  --       runner.run_range,
  --       { desc = "[r]un visual range", silent = true }
  --     )
  --   end,
  -- },
}
