-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Line wrapping (VSCode style: wrapped lines stay indented and break cleanly)
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- Indentation (Standard 2 spaces for HDL & scripts)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Clipboard & undo persistence (explicit provider for VMware / X11 compatibility)
if vim.fn.executable("xsel") == 1 then
  vim.g.clipboard = {
    name = "xsel",
    copy = {
      ["+"] = "xsel --clipboard --input",
      ["*"] = "xsel --primary --input",
    },
    paste = {
      ["+"] = "xsel --clipboard --output",
      ["*"] = "xsel --primary --output",
    },
    cache_enabled = 0,
  }
end
opt.clipboard = "unnamedplus"
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Default commentstring fallback (prevents "'commentstring' is empty" error)
opt.commentstring = "// %s"

-- Filetype detection for Hardware (EDA/ASIC), Verilog headers, and constraint scripts
vim.filetype.add({
  extension = {
    vh = "verilog",        -- Verilog header files
    svh = "systemverilog", -- SystemVerilog header files
    sdc = "sdc",           -- Synopsys Design Constraints
    xdc = "sdc",           -- Xilinx Design Constraints
    upf = "tcl",           -- Unified Power Format
    cpf = "tcl",           -- Common Power Format
    vhd = "vhdl",
    vhdl = "vhdl",
  },
})

-- Ensure commentstring is never empty for any buffer (JSON, scratch, new files)
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  callback = function()
    if vim.bo.commentstring == "" then
      local ft = vim.bo.filetype
      if ft == "tcl" or ft == "sdc" or ft == "xdc" or ft == "upf" or ft == "cpf" or ft == "sh" or ft == "bash" or ft == "python" then
        vim.bo.commentstring = "# %s"
      else
        vim.bo.commentstring = "// %s"
      end
    end
  end,
})

-- Highlight yanked text briefly (visual feedback on yy, y, etc.)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight text when yanking",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 250 })
  end,
})

-- Open help windows vertically on the right side instead of at the bottom
vim.api.nvim_create_autocmd("FileType", {
  desc = "Open help on the right",
  pattern = "help",
  callback = function()
    vim.cmd("wincmd L")
  end,
})
