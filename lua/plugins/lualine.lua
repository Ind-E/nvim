return {
  "lualine.nvim",
  -- event = "DeferredUIEnter",
  after = function ()
    require("lualine").setup({
      options = {
        component_separators = { left = "", right = "" },
        section_separator = { left = "", right = "" },
        globalStatus = true,
        ignore_focus = { "yazi" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icons_enabled = true,
            separator = {
              left = "",
              right = "",
            },
          },
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
        },
        lualine_b = {
          {
            "filetype",
            colored = true,
            icon_only = true,
            icon = { align = "left" },
          },
          {
            "filename",
            symbols = { modified = " ", readonly = " " },
            separator = { right = "" },
          },
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
        },
        lualine_c = {
          {
            "diff",
            colored = false,
            diff_color = {
              added = "DifAdd",
              modified = "DiffChange",
              removed = "DiffDelete",
            },
            symbols = { added = "+", modified = "~", removed = "-" },
            separator = { right = "" },
          },
        },
        lualine_x = {
          {
            function ()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })

              if vim.tbl_isempty(clients) then
                return "No Active LSP"
              end

              local active_clients = {}
              for _, client in ipairs(clients) do
                table.insert(active_clients, client.name)
              end

              return table.concat(active_clients, ", ")
            end,
            icon = " ",
            separator = { left = "" },
          },
          {
            "diagnostics",
            sources = { "nvim_lsp", "nvim_diagnostic", "vim_lsp", "coc" },
            symbols = { error = "󰅙 ", warn = " ", hint = "󰌵" },
            colored = true,
            update_in_insert = false,
            always_visible = false,
            diagnostics_color = {
              color_error = { fg = "red" },
              color_warn = { fg = "yellow" },
              color_nfo = { fg = "cyan" },
            },
          },
        },
        lualine_y = {
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
          {
            "searchcount",
            maxcount = 999,
            timeout = 120,
            separator = { left = "" },
          },
          {
            "branch",
            icon = "",
            separator = { left = "" },
          },
        },
        lualine_z = {
          {
            "",
            draw_empty = true,
            separator = { left = "", right = "" },
          },
          {
            "progress",
            separator = { left = "" },
          },
          {
            "location",
          },
          {
            "fileformat",
            color = { fg = "black" },
            symbols = {
              unix = "",
              dos = "",
              mac = "",
            },
          },
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
          },
        },
        lualine_x = {
          {
            "location",
          },
        },
      },
    })
  end,
}
