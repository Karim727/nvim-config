-- Ensure local node and binaries are in PATH for Mason and tools
local node_bin = vim.fn.expand("$HOME/.local/share/node/bin")
local local_bin = vim.fn.expand("$HOME/.local/bin")
vim.env.PATH = node_bin .. ":" .. local_bin .. ":" .. vim.env.PATH

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
