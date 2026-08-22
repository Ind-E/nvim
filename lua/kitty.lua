require("lze").load({
  {
    "kitty-scrollback.nvim",
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    after = function ()
      require("kitty-scrollback").setup()
    end,
  },
})
