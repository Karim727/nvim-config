return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false, -- Display files ignored by .gitignore in file tree
        },
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
      },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["C"] = "set_root",
          ["."] = {
            function(state)
              local node = state.tree:get_node()
              if not node then
                return
              end
              local path = node:get_id()
              if vim.fn.isdirectory(path) ~= 1 then
                path = vim.fs.dirname(path)
              end
              if path and vim.fn.isdirectory(path) == 1 then
                vim.cmd("cd " .. vim.fn.fnameescape(path))
                pcall(function()
                  require("neo-tree.sources.filesystem.commands").set_root(state)
                end)
                vim.notify("CWD: " .. path, vim.log.levels.INFO, { title = "Neo-tree" })
              end
            end,
            desc = "Change CWD to selected directory",
          },
          ["o"] = {
            function(state)
              local node = state.tree:get_node()
              if not node then
                return
              end
              local path = node:get_id() or node.path
              if path then
                if vim.fn.executable("xdg-open") == 1 then
                  vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                else
                  vim.ui.open(path)
                end
                vim.notify("Opened with system app: " .. vim.fs.basename(path), vim.log.levels.INFO, { title = "Neo-tree" })
              end
            end,
            desc = "Open with System Application (xdg-open)",
          },
        },
      },
    },
  },
}
