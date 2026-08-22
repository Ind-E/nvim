return {
  {
    "nvim-treesitter",
    lazy = false,
    auto_enable = true,
    after = function ()
      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach (buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return false
        end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        -- ensure folds are open to begin with
        vim.o.foldlevel = 99

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        return true
      end

      local installable_parsers = require("nvim-treesitter").get_available()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function (args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          if not treesitter_try_attach(buf, language) then
            if vim.tbl_contains(installable_parsers, language) then
              -- not already installed, so try to install them via nvim-treesitter if possible
              require("nvim-treesitter").install(language):await(function ()
                treesitter_try_attach(buf, language)
              end)
            end
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter-textobjects",
    auto_enable = true,
    lazy = false,
    before = function ()
      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#using-a-package-manager
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    after = function ()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = false,
        },
      })
      vim.keymap.set({ "x", "o" }, "am", function ()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@function.outer",
          "textobjects"
        )
      end)
      vim.keymap.set({ "x", "o" }, "im", function ()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@function.inner",
          "textobjects"
        )
      end)
      vim.keymap.set({ "x", "o" }, "ac", function ()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@class.outer",
          "textobjects"
        )
      end)
      vim.keymap.set({ "x", "o" }, "ic", function ()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@class.inner",
          "textobjects"
        )
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function ()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@local.scope",
          "locals"
        )
      end)

      -- movement

      vim.keymap.set({ "n", "x", "o" }, "]m", function ()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@function.outer",
          "textobjects"
        )
      end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function ()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@class.outer",
          "textobjects"
        )
      end)
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ "n", "x", "o" }, "]s", function ()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@local.scope",
          "locals"
        )
      end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function ()
        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]M", function ()
        require("nvim-treesitter-textobjects.move").goto_next_end(
          "@function.outer",
          "textobjects"
        )
      end)
      vim.keymap.set({ "n", "x", "o" }, "][", function ()
        require("nvim-treesitter-textobjects.move").goto_next_end(
          "@class.outer",
          "textobjects"
        )
      end)

      vim.keymap.set({ "n", "x", "o" }, "[m", function ()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@function.outer",
          "textobjects"
        )
      end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function ()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@class.outer",
          "textobjects"
        )
      end)

      vim.keymap.set({ "n", "x", "o" }, "[M", function ()
        require("nvim-treesitter-textobjects.move").goto_previous_end(
          "@function.outer",
          "textobjects"
        )
      end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function ()
        require("nvim-treesitter-textobjects.move").goto_previous_end(
          "@class.outer",
          "textobjects"
        )
      end)
    end,
  },
}
