return {
  {
    "nvim-dap",
    event = "DeferredUIEnter",
    dep_of = { "nvim-jdtls" },
    load = function (name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("nvim-dap-ui")
      vim.cmd.packadd("nvim-dap-virtual-text")
    end,
    after = function (plugin)
      local dap = require("dap")
      local dapui = require("dapui")

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set(
        "n",
        "<leader>B",
        dap.toggle_breakpoint,
        { desc = "Debug: Toggle Breakpoint" }
      )
      vim.keymap.set(
        "n",
        "<F7>",
        dapui.toggle,
        { desc = "Debug: See last session result." }
      )

      vim.keymap.set("n", "<leader>Dq", function ()
        dap.terminate()
        dap.clear_breakpoints()
      end, { desc = "Debug: Terminate and clear breakpoints" })

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      dapui.setup({})

      dap.adapters.coreclr = {
        type = "executable",
        command = "steam-run",
        args = { "netcoredbg", "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch STS2",
          request = "launch",
          program = "${env:HOME}/.local/share/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2",
          cwd = "${env:HOME}/.local/share/Steam/steamapps/common/Slay the Spire 2/",
          stopAtEntry = false,
          justMyCode = false,
        },
      }

      require("nvim-dap-virtual-text").setup({
        enable_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,

        display_callback = function (variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
      })
    end,
  },
  {
    "nvim-nio",
    dep_of = { "nvim-dap" },
  },
}
