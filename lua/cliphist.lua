_G.Cliphist = function ()
  local snacks = require("snacks")

  snacks.picker.pick({
    name = "cliphist",
    finder = function ()
      local items = {}
      local rows = vim.fn.systemlist("cliphist list")
      for _, row in ipairs(rows) do
        local id, content = row:match("^(%d+)[\t%s]+(.*)$")
        if id then
          local is_binary = content:find("^%[%[%s+binary data") ~= nil
          table.insert(items, {
            id = id,
            row = row,
            -- Display text for the list
            text = is_binary and "🖼️  (Image) " .. (content:match(
              "binary data%s+(.*)%s+%]%]"
            ) or "Image") or content,
            is_image = is_binary,
          })
        end
      end
      return items
    end,
    format = "text",
    preview = function (ctx)
      local item = ctx.item
      if not item then
        return
      end

      if item.is_image then
        -- 1. Decode to temp file
        local tmp = vim.fn.tempname() .. ".png"
        vim.fn.system(
          string.format(
            "echo %s | cliphist decode > %s",
            vim.fn.shellescape(item.row),
            tmp
          )
        )

        -- 2. Inject 'file' path so the built-in previewer knows what to load
        item.file = tmp

        -- 3. Call the built-in file previewer (handles Kitty graphics + cleanup)
        return require("snacks.picker.preview").file(ctx)
      else
        -- 4. Text decoding
        local data = vim.fn.system(
          string.format("echo %s | cliphist decode", vim.fn.shellescape(item.row))
        )
        vim.api.nvim_set_option_value("modifiable", true, { buf = ctx.buf })
        vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, vim.split(data, "\n"))
        vim.api.nvim_set_option_value("filetype", "text", { buf = ctx.buf })
        vim.api.nvim_set_option_value("modifiable", false, { buf = ctx.buf })
      end
    end,
    confirm = function (picker, item)
      if item then
        -- Execute the copy logic from your bash script
        vim.fn.system(
          string.format(
            "echo %s | cliphist decode | wl-copy",
            vim.fn.shellescape(item.row)
          )
        )
      end
      picker:close() -- Triggers on_close
    end,
    on_close = function ()
      -- This ensures Neovim quits whether you selected an item OR pressed Esc
      vim.schedule(function ()
        vim.cmd("qa!")
      end)
    end,
    layout = { preset = "sidebar" },
  })
end
