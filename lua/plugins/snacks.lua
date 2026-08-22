return {
  {
    "snacks.nvim",
    lazy = false,
    -- event = "DeferredUIEnter",
    keys = {
      {
        "<leader>d",
        function ()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>b",
        function ()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "gr",
        function ()
          Snacks.picker.lsp_references()
        end,
        desc = "References",
      },
      {
        "<leader>ls",
        function ()
          Snacks.picker.lsp_symbols()
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>lS",
        function ()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>/",
        function ()
          local git_dir = vim.fn.system(
            string.format(
              "git -C %s rev-parse --show-toplevel",
              vim.fn.expand("%:p:h")
            )
          )
          git_dir = string.gsub(git_dir, "\n", "")
          if git_dir ~= "" then
            Snacks.picker.grep({ cwd = git_dir })
          else
            Snacks.picker.grep()
          end
        end,
        desc = "Grep",
      },
      {
        "<leader>'",
        function ()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },

      {
        "<leader>f",
        function ()
          vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
          if vim.v.shell_error == 0 then
            Snacks.picker.git_files()
          else
            Snacks.picker.smart()
          end
        end,
        desc = "Files",
      },
      {
        "<leader>F",
        function ()
          Snacks.picker.smart()
        end,
        desc = "All Files",
      },
      {
        "<leader>z",
        function ()
          Snacks.picker.lines()
        end,
        desc = "Fuzzy Find",
      },
      {
        "<leader>gB",
        function ()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function ()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function ()
          Snacks.picker.git_log_line()
        end,
        desc = "Git Log Line",
      },
      {
        "<leader>gs",
        function ()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gd",
        function ()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function ()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log File",
      },
      -- gh
      {
        "<leader>ghi",
        function ()
          Snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>ghI",
        function ()
          Snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>ghp",
        function ()
          Snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>ghP",
        function ()
          Snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
      },

      -- search
      {
        '<leader>s"',
        function ()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function ()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function ()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>sb",
        function ()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sc",
        function ()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function ()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function ()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function ()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function ()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function ()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function ()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function ()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function ()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function ()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function ()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function ()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sq",
        function ()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function ()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function ()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>ss",
        function ()
          Snacks.picker.lsp_symbols()
        end,
        desc = "Symbols",
      },
      {
        "<leader>sS",
        function ()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>sn",
        function ()
          Snacks.picker.notifications()
        end,
        desc = "Notifications",
      },
      {
        "<leader>sp",
        function ()
          Snacks.picker.pickers()
        end,
        desc = "Pickers",
      },
      {
        "<leader>st",
        function ()
          Snacks.picker.tags()
        end,
        desc = "Tags",
      },
    },

    after = function ()
      require("snacks").setup({
        picker = {
          ui_select = true,
        },
        notifier = {
          width = { min = 40, max = 0.6 },
          style = "minimal",
        },
      })
    end,
  },
}
