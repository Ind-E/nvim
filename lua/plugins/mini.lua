return {
  {
    "mini.trailspace",
    event = "DeferredUIEnter",
    after = function ()
      require("mini.trailspace").setup({})

      vim.g.trim_trailing_ws_on_save = true

      vim.keymap.set("n", "<leader>tt", function ()
        vim.g.trim_trailing_ws_on_save = not vim.g.trim_trailing_ws_on_save
        print("Trim on save: " .. (vim.g.trim_trailing_ws_on_save and "ON" or "OFF"))
      end, { noremap = true, desc = "Toggle Trim Whitespace on Save" })

      vim.keymap.set("n", "<leader>tw", function ()
        require("mini.trailspace").trim()
      end, { noremap = true, desc = "Trim Whitespace Now" })

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function ()
          if vim.g.trim_trailing_ws_on_save then
            require("mini.trailspace").trim()
          end
        end,
      })
    end,
  },
  {
    "mini.surround",
    event = "DeferredUIEnter",
    after = function ()
      require("mini.surround").setup()
    end,
  },
  {
    "mini.align",
    cat = "full",
    event = "DeferredUIEnter",
    after = function ()
      require("mini.align").setup({
        mappings = {
          start_with_preview = "gA",
          start = "",
        },
      })
    end,
  },
  {
    "mini.splitjoin",
    event = "DeferredUIEnter",
    after = function ()
      require("mini.splitjoin").setup()
    end,
  },
  {
    "mini.ai",
    event = "DeferredUIEnter",
    after = function ()
      require("mini.ai").setup()
    end,
  },
  {
    "mini.pairs",
    event = "DeferredUIEnter",
    after = function ()
      require("mini.pairs").setup({
        mappings = {
          ["'"] = false,
          ['"'] = false,
          ["`"] = false,
          ["("] = { neigh_pattern = '^.[^%w-"]' },
          ["{"] = { neigh_pattern = '^.[^%w-"]' },
          ["["] = { neigh_pattern = '^.[^%w-"]' },
        },
      })

      local map_typst = function ()
        MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" })
      end
      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = "typ", callback = map_typst }
      )
    end,
  },
}
