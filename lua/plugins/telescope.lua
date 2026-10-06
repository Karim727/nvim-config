return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Quick Open)" },
      { "<leader>ff", LazyVim.pick("files", { no_ignore = true }), desc = "Find Files (Root Dir, with gitignore)" },
      { "<leader><space>", LazyVim.pick("files", { no_ignore = true }), desc = "Find Files (Root Dir, with gitignore)" },
      { "<leader>fF", LazyVim.pick("files", { root = false, no_ignore = true }), desc = "Find Files (cwd, with gitignore)" },
      { "<leader>fg", LazyVim.pick("live_grep"), desc = "Grep Files (Root Dir)" },
      { "<leader>fG", LazyVim.pick("live_grep", { root = false }), desc = "Grep Files (cwd)" },
    },
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}

      -- Search inside .gitignore files in live grep text search
      opts.defaults.vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--no-ignore",
        "--hidden",
        "-g",
        "!.git",
      }

      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = {
        find_command = function()
          return { "rg", "--files", "--color", "never", "--no-ignore", "--hidden", "-g", "!.git" }
        end,
        no_ignore = true,
        hidden = true,
      }
      opts.pickers.live_grep = {
        additional_args = function()
          return { "--no-ignore", "--hidden", "-g", "!.git" }
        end,
      }
    end,
  },
}
