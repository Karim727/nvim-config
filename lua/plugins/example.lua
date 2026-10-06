-- ============================================================================
-- Custom Plugins & Extra Features Example File
-- Location: ~/.config/nvim/lua/plugins/example.lua
-- ============================================================================
--
-- How this works:
-- LazyVim automatically loads ANY .lua file placed inside ~/.config/nvim/lua/plugins/
-- Each file returns a Lua table containing plugin specifications: return { ... }
--
-- To enable any example below, simply remove the comment dashes (--) from that block!
-- You can also add your own new plugins directly into this file.
-- ============================================================================

return {

	-- ========================================================================
	-- 1. HOW TO CHANGE THE UI THEME / COLORSCHEME
	-- ========================================================================
	-- If you want to change your theme, add the theme plugin and tell LazyVim to use it.
	-- (Pick ONE of these or add your favorite):

	-- Option A: Catppuccin (Mocha, Macchiato, Frappe, Latte)
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	opts = {
	-- 		flavour = "latte", -- "latte", "frappe", "macchiato", "mocha"
	-- 	},
	-- },
	-- -- {
	--   "LazyVim/LazyVim",
	--   opts = {
	--     colorscheme = "catppuccin",
	--   },
	-- },

	-- Option B: Gruvbox
	{ "ellisonleao/gruvbox.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},

	-- Option C: Rose Pine
	-- { "rose-pine/neovim", name = "rose-pine" },
	-- {
	-- 	"LazyVim/LazyVim",
	-- 	opts = {
	-- 		colorscheme = "rose-pine",
	-- 	},
	-- },

	-- Option D: Nord
	-- { "shaunsingh/nord.nvim" },
	-- {
	--   "LazyVim/LazyVim",
	--   opts = {
	--     colorscheme = "nord",
	--   },
	-- },

	-- Option E: Solarized Osaka
	-- {
	--   "craftzdog/solarized-osaka.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   opts = {},
	-- },
	-- {
	--   "LazyVim/LazyVim",
	--   opts = {
	--     colorscheme = "solarized-osaka",
	--   },
	-- },

	-- ========================================================================
	-- 2. POPULAR EXTRA FEATURES (PLUGINS)
	-- ========================================================================

	-- Surround text with quotes, brackets, tags: ys (add), ds (delete), cs (change)
	-- e.g. cs"' changes "hello" to 'hello'
	-- {
	--   "kylechui/nvim-surround",
	--   version = "*", -- use for stability
	--   event = "VeryLazy",
	--   config = function()
	--     require("nvim-surround").setup({})
	--   end,
	-- },

	-- Highlight and search TODO, FIX, BUG, NOTE comments in your code
	-- {
	--   "folke/todo-comments.nvim",
	--   dependencies = { "nvim-lua/plenary.nvim" },
	--   opts = {},
	-- },

	-- Rainbow colored parenthesis / brackets to make nested code easy to read
	-- {
	--   "HiPhish/rainbow-delimiters.nvim",
	--   event = "VeryLazy",
	-- },

	-- Git Diff viewer and review tool (:DiffviewOpen)
	-- {
	--   "sindrets/diffview.nvim",
	--   cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
	-- },

	-- ========================================================================
	-- 3. ADDING A PLUGIN WITH CUSTOM KEYMAPS
	-- ========================================================================
	-- You can bind custom keys directly within a plugin specification:
	-- {
	--   "mbbill/undotree",
	--   keys = {
	--     { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
	--   },
	-- },

	-- ========================================================================
	-- 4. OVERRIDING OPTIONS FOR EXISTING PLUGINS
	-- ========================================================================
	-- If LazyVim already has a plugin (like lualine, bufferline, telescope, etc.),
	-- you don't need to reinstall it. Just specify its repo name and the `opts` you want:

	-- Example: Customize the bottom statusline (lualine)
	-- {
	--   "nvim-lualine/lualine.nvim",
	--   opts = function(_, opts)
	--     -- Change lualine options or theme here
	--   end,
	-- },

	-- ========================================================================
	-- 5. DISABLING A PLUGIN YOU DON'T WANT
	-- ========================================================================
	-- If LazyVim enables a plugin you don't like, simply disable it:
	-- { "folke/noice.nvim", enabled = false },

	-- ========================================================================
	-- 6. YOUR OWN CUSTOM PLUGINS HERE
	-- ========================================================================
	-- Simply add any GitHub repository here: "username/repository-name"
	-- Example:
	-- { "author/plugin-name" },
}
