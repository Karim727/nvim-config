-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Clear search highlights on pressing Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Keep cursor centered when scrolling / jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Toggle line wrap (VSCode Alt+Z style & leader uw)
map("n", "<A-z>", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- Better navigation through wrapped lines (moves by visual line instead of physical line)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Delete word backwards with Ctrl + Backspace / Ctrl + h in Insert and Command modes
map("i", "<C-BS>", "<C-w>", { desc = "Delete word backwards" })
map("i", "<C-h>", "<C-w>", { desc = "Delete word backwards" })
map("c", "<C-BS>", "<C-w>", { desc = "Delete word backwards in command line" })
map("c", "<C-h>", "<C-w>", { desc = "Delete word backwards in command line" })

-- Delete or change without overwriting the default yank register
map({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = "Paste without overwriting yank buffer" })

-- Commenting shortcuts (VSCode Ctrl+/ and leader /)
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment line" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment selection" })
map("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment selection" })
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

-- Tab / Buffer management (VSCode style)
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Tab" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Tab" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Tab" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Tab" })
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Tab" })
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Tab" })
map("n", "<leader>bd", function()
  if package.loaded["snacks"] and Snacks.bufdelete then
    Snacks.bufdelete()
  else
    vim.cmd("bprevious | bdelete #")
  end
end, { desc = "Close current tab" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other tabs" })

-- Toggle file explorer with VSCode style <C-b>
map("n", "<C-b>", "<cmd>Neotree toggle<CR>", { desc = "Toggle File Explorer" })

-- Goto Definition (Smart LSP + Verilog/SystemVerilog + Hidden Folders)
map("n", "gd", function()
  require("util.def").goto_definition()
end, { desc = "Goto Definition (Smart LSP + Verilog/Hidden)" })
map("n", "<C-]>", function()
  require("util.def").goto_definition()
end, { desc = "Goto Definition (Smart LSP + Verilog/Hidden)" })
