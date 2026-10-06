-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function setup_clean_dir_startup()
  if vim.fn.argc() ~= 1 then
    return
  end
  local arg = vim.fn.argv(0)
  if arg == "" or vim.fn.isdirectory(arg) ~= 1 then
    return
  end

  -- Wait for Neo-tree netrw hijack to complete
  vim.defer_fn(function()
    -- Find the main editing window (not neo-tree)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype ~= "neo-tree" then
        vim.api.nvim_set_current_win(win)
        pcall(function()
          Snacks.dashboard({ buf = buf, win = win })
        end)
        break
      end
    end

    -- Unlist any empty unnamed buffer so Bufferline never shows a "[No Name]" tab
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[b].filetype ~= "neo-tree" and vim.bo[b].filetype ~= "snacks_dashboard" then
        if vim.api.nvim_buf_get_name(b) == "" and vim.bo[b].buftype == "" and not vim.bo[b].modified then
          vim.bo[b].buflisted = false
        end
      end
    end

    -- Refocus Neo-tree sidebar so the user can immediately browse files with j/k/<CR>
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "neo-tree" then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  end, 50)
end

-- Prevent empty [No Name] buffer when starting with a directory (e.g. `nvim .`)
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open dashboard instead of empty buffer when starting with a directory",
  callback = setup_clean_dir_startup,
})

-- Whenever a real file is opened, wipe any leftover empty [No Name] buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Drop empty [No Name] buffer when a real file is opened",
  callback = function(args)
    vim.schedule(function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if b ~= args.buf and
           vim.bo[b].buftype == "" and
           vim.api.nvim_buf_get_name(b) == "" and
           not vim.bo[b].modified and
           vim.api.nvim_buf_line_count(b) == 1 and
           vim.api.nvim_buf_get_lines(b, 0, 1, false)[1] == "" and
           #vim.fn.win_findbuf(b) == 0 then
          pcall(vim.api.nvim_buf_delete, b, { force = true })
        end
      end
    end)
  end,
})
