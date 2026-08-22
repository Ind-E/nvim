return {
  {
    "nvim-lint",
    event = "FileType",
    after = function ()
      require("lint").linters_by_ft = {
        bash = { "shellcheck" },
        nix = { "statix" },
        fish = { "fish" },
        yaml = { "yamllint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function ()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
