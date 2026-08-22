vim.loader.enable()
do
  -- Set up a global in a way that also handles non-nix compat
  local ok
  ok, _G.nixInfo = pcall(require, vim.g.nix_info_plugin_name)
  if not ok then
    package.loaded[vim.g.nix_info_plugin_name] = setmetatable({}, {
      __call = function (_, default)
        return default
      end,
    })
    _G.nixInfo = require(vim.g.nix_info_plugin_name)
    -- If you always use the fetcher function to fetch nix values,
    -- rather than indexing into the tables directly,
    -- it will use the value you specified as the default
    -- TODO: for non-nix compat, vim.pack.add in another file and require here.
  end
  nixInfo.isNix = vim.g.nix_info_plugin_name ~= nil
  ---@module 'lzextras'
  ---@type lzextras | lze
  nixInfo.lze = setmetatable(require("lze"), getmetatable(require("lzextras")))

  function nixInfo.get_nix_plugin_path (name)
    return nixInfo(nil, "plugins", "lazy", name)
      or nixInfo(nil, "plugins", "start", name)
  end

  function nixInfo.cat (name)
    if not vim.g.nix_info_plugin_name then
      return true
    end

    return nixInfo(false, "settings", "cats", name)
  end
end

nixInfo.lze.register_handlers({
  {
    -- adds an `auto_enable` field to lze specs
    -- if true, will disable it if not installed by nix.
    -- if string, will disable if that name was not installed by nix.
    -- if a table of strings, it will disable if any were not.
    spec_field = "auto_enable",
    set_lazy = false,
    modify = function (plugin)
      if vim.g.nix_info_plugin_name then
        if type(plugin.auto_enable) == "table" then
          for _, name in pairs(plugin.auto_enable) do
            if not nixInfo.get_nix_plugin_path(name) then
              plugin.enabled = false
              break
            end
          end
        elseif type(plugin.auto_enable) == "string" then
          if not nixInfo.get_nix_plugin_path(plugin.auto_enable) then
            plugin.enabled = false
          end
        elseif type(plugin.auto_enable) == "boolean" and plugin.auto_enable then
          if not nixInfo.get_nix_plugin_path(plugin.name) then
            plugin.enabled = false
          end
        end
      end
      return plugin
    end,
  },
  {
    spec_field = "cat",
    set_lazy = false,
    modify = function (plugin)
      if vim.g.nix_info_plugin_name then
        if type(plugin.cat) == "string" then
          plugin.enabled = nixInfo(false, "settings", "cats", plugin.cat)
        end
      end
      return plugin
    end,
  },
  nixInfo.lze.lsp,
})

nixInfo.lze.h.lsp.set_ft_fallback(function (name)
  local lspcfg = nixInfo.get_nix_plugin_path("nvim-lspconfig")
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    return (ok and cfg or {}).filetypes or {}
  else
    return (vim.lsp.config[name] or {}).filetypes or {}
  end
end)

require("options")
require("keymaps")

require("plugins")
require("LSPs")

nixInfo.lze.load({
  {
    "vscode.nvim",
    after = function ()
      require("vscode.colors").get_colors()
      require("vscode").setup({
        transparent = true,
        color_overrides = {
          vscBack = "#000000",
          vscCursorDarkDark = "#171717",
          vscLeftDark = "#000000",
          vscPopupBack = "#000000",
          vscTabOutside = "#000000",
        },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },
})
