local load_w_after = function (name)
  vim.cmd.packadd(name)
  vim.cmd.packadd(name .. "/after")
end

return {
  {
    "cmp-cmdline",
    on_plugin = { "blink.cmp" },
    load = load_w_after,
  },
  {
    "blink-compat",
    dep_of = { "cmp-cmdline" },
  },
  {
    "colorful-menu.nvim",
    on_plugin = { "blink.cmp" },
  },
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    after = function ()
      require("blink.cmp").setup({
        keymap = {
          preset = "super-tab",
        },
        sources = {
          default = { "lsp", "path", "snippets" },
        },
        cmdline = {
          keymap = {
            preset = "inherit",
          },
          completion = {
            menu = {
              auto_show = true,
            },
          },
          sources = function ()
            local type = vim.fn.getcmdtype()
            if type == "/" or type == "?" then
              return { "buffer" }
            end
            if type == ":" or type == "@" then
              return { "cmdline" }
            end
            return {}
          end,
        },
        fuzzy = {
          sorts = {
            "exact",
            "score",
            "sort_text",
          },
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },
        completion = {
          menu = {
            draw = {
              treesitter = { "lsp" },
              components = {
                label = {
                  text = function (ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function (ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
          },
        },
      })
    end,
  },
}
