return {
  -- Theme configuration
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },

  -- Which-key helper popup (docked on the right side instead of the bottom)
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      win = {
        col = -1, -- Right side of the screen
        border = "rounded",
      },
    },
  },

  -- VSCode-style top tabs
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        mode = "buffers",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = "thin",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        custom_filter = function(bufnr)
          -- Don't show unnamed empty scratch buffers in the tab line
          local name = vim.api.nvim_buf_get_name(bufnr)
          if name == "" and vim.bo[bufnr].buftype == "" and not vim.bo[bufnr].modified then
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            if #lines <= 1 and (lines[1] == "" or lines[1] == nil) then
              return false
            end
          end
          return true
        end,
      },
    },
  },
}
