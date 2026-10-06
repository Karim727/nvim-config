return {
  -- Quick letter navigation (flash.nvim with jump labels)
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          jump_labels = true, -- Shows direct letter labels for f/F/t/T navigation
        },
      },
    },
  },

  -- Commenting engine with custom hardware language support
  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        sdc = "# %s",
        xdc = "# %s",
        upf = "# %s",
        cpf = "# %s",
        tcl = "# %s",
      },
    },
  },
}
