return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "gd",
              function()
                require("util.def").goto_definition()
              end,
              desc = "Goto Definition (Smart LSP + Verilog/Hidden)",
            },
          },
        },
        pyright = {},
        bashls = {},
        verible = {
          cmd = { "verible-verilog-ls", "--rules_config_search" },
          filetypes = { "systemverilog", "verilog" },
          root_dir = function(bufnr_or_fname)
            local fname = type(bufnr_or_fname) == "number" and vim.api.nvim_buf_get_name(bufnr_or_fname) or bufnr_or_fname
            if not fname or fname == "" then
              return vim.uv.cwd()
            end
            local root = nil
            if vim.fs.root then
              root = vim.fs.root(fname, { ".git", "verible.filelist", "*.sv", "*.v" })
            end
            return root or vim.fs.dirname(fname) or vim.uv.cwd()
          end,
        },
      },
    },
  },
}
