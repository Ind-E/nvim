-- move virtual lines to end of line instead of above

local orig_view = vim.fn.winrestview
---@diagnostic disable-next-line: duplicate-set-field
vim.fn.winrestview = function (v)
  if not (v and v.topfill) then
    return orig_view(v)
  end
end

local orig_extmark = vim.api.nvim_buf_set_extmark
local ns_ids = {}

---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim_buf_set_extmark = function (buf, ns, row, col, opts)
  if ns_ids[ns] == nil then
    for name, id in pairs(vim.api.nvim_get_namespaces()) do
      if id == ns then
        ns_ids[ns] = name:find("lsp.codelens", 1, true) ~= nil
        break
      end
    end
  end

  if ns_ids[ns] and opts and opts.virt_lines then
    local vt = {}
    for _, line in ipairs(opts.virt_lines) do
      for _, chunk in ipairs(line) do
        local text = chunk[1]:gsub("^%s+", "")
        if text ~= "" then
          vt[#vt + 1] = { "  " .. text, chunk[2] }
        end
      end
    end
    opts.virt_lines, opts.virt_lines_above = nil, nil
    opts.virt_text, opts.virt_text_pos = vt, "eol"
  end
  return orig_extmark(buf, ns, row, col, opts)
end

return function (_, bufnr)
  local nmap = function (keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>e", vim.diagnostic.open_float, "Error Float")

  nmap("<leader>r", vim.lsp.buf.rename, "Rename Symbol")
  nmap("<leader>a", vim.lsp.buf.code_action, "Code Action")

  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
  nmap("gi", vim.lsp.buf.implementation, "Implementations")
  nmap("]d", function ()
    vim.diagnostic.jump({
      count = vim.v.count1,
      float = true,
    })
  end, "Jump to the next diagnostic")
  nmap("[d", function ()
    vim.diagnostic.jump({
      count = -vim.v.count1,
      float = true,
    })
  end, "Jump to the previous diagnostic")
  nmap("]e", function ()
    vim.diagnostic.jump({
      count = vim.v.count1,
      severity = vim.diagnostic.severity.ERROR,
      float = true,
    })
  end, "Jump to the next error")
  nmap("[e", function ()
    vim.diagnostic.jump({
      count = -vim.v.count1,
      severity = vim.diagnostic.severity.ERROR,
    })
  end, "Jump to the previous error")
end
