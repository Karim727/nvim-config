return {
  -- Quick letter navigation (flash.nvim with jump labels, freeing 'S' for surround)
  {
    "folke/flash.nvim",
    keys = {
      { "S", mode = { "n", "x", "o" }, false }, -- Free 'S' for nvim-surround
    },
    opts = {
      modes = {
        char = {
          jump_labels = true, -- Shows direct letter labels for f/F/t/T navigation
        },
      },
    },
  },

  -- nvim-surround with visual mode 'S'
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
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
