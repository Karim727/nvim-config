return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        bashls = {},
        verible = {
          cmd = { "verible-verilog-ls", "--rules_config_search" },
        },
        veridian = {
          cmd = { "veridian" },
          filetypes = { "systemverilog", "verilog" },
          root_dir = function(fname)
            return vim.fs.dirname(vim.fs.find({ ".git", "*.sv", "*.v" }, { path = fname, upward = true })[1])
          end,
        },
      },
    },
  },
}
