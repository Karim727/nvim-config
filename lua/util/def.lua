local M = {}

--- Efficiently finds the project root without traversing up to $HOME or system roots
local function get_project_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(fname)
  if not dir or dir == "" then
    return vim.uv.cwd()
  end

  local marker = vim.fs.find(
    { ".git", "verible.filelist", "flist", "flist.yaml", "Makefile", "*.core", "*.eda" },
    { path = dir, upward = true }
  )[1]

  if marker then
    return vim.fs.dirname(marker)
  end

  local cwd = vim.uv.cwd()
  local home = vim.env.HOME
  -- If opened from $HOME, root, or /tmp, confine search to the file's parent folder
  if cwd == home or cwd == "/" or cwd == "/tmp" then
    return dir
  end
  return cwd
end

--- Instant check: Is the definition in the current open buffer? (< 1ms)
local function search_current_buffer(bufnr, word, is_verilog)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local patterns = {}
  if is_verilog then
    table.insert(patterns, "^%s*module%s+" .. word .. "[%s;#%(]")
    table.insert(patterns, "^%s*macromodule%s+" .. word .. "[%s;#%(]")
    table.insert(patterns, "^%s*interface%s+" .. word .. "[%s;#%(]")
    table.insert(patterns, "^%s*package%s+" .. word .. "[%s;#%(]")
    table.insert(patterns, "^%s*class%s+" .. word .. "[%s;#%(]")
    table.insert(patterns, "^%s*program%s+" .. word .. "[%s;#%(]")
    table.insert(patterns, "^%s*task%s+.*%f[%w]" .. word .. "%f[^%w]")
    table.insert(patterns, "^%s*function%s+.*%f[%w]" .. word .. "%f[^%w]")
    table.insert(patterns, "^%s*`define%s+" .. word .. "%f[^%w]")
  end

  for _, pat in ipairs(patterns) do
    for lnum, line in ipairs(lines) do
      local s, e = line:find(pat)
      if s then
        return {
          filename = vim.api.nvim_buf_get_name(bufnr),
          lnum = lnum,
          col = s,
          text = vim.trim(line),
        }
      end
    end
  end
  return nil
end

--- Lightning-fast ripgrep targeting ONLY source files and excluding massive simulation/dump files
local function search_ripgrep(pattern, root, globs)
  local cmd = {
    "rg",
    "--hidden",
    "--no-ignore",
    "--one-file-system",
    "-g", "!.git/**",
    "-g", "!.mount*/**",
    "-g", "!*.{log,vcd,fsdb,wlf,vpd,dump,dat,hex,mem,csv,rpt,out,summary,tar,gz,zip,bin,o,so,a}",
    "-g", "!node_modules/**",
    "-g", "!build/**",
    "-g", "!target/**",
    "--max-columns", "300",
    "--max-depth", "8",
    "-n",
    "--column",
    "--no-heading",
  }

  if globs and #globs > 0 then
    for _, g in ipairs(globs) do
      table.insert(cmd, "-g")
      table.insert(cmd, g)
    end
  end

  table.insert(cmd, pattern)
  table.insert(cmd, root)

  local obj = vim.system(cmd):wait()
  local matches = {}
  if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
    for line in obj.stdout:gmatch("[^\r\n]+") do
      local file, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
      if file and lnum then
        table.insert(matches, {
          filename = file,
          lnum = tonumber(lnum),
          col = tonumber(col) or 1,
          text = vim.trim(text or ""),
        })
      end
    end
  end
  return matches
end

--- Jump to a match and record in jumplist
local function jump_to(match, word)
  vim.cmd("normal! m'") -- Record current position in jump list (so Ctrl-o jumps back)
  vim.cmd("edit +" .. match.lnum .. " " .. vim.fn.fnameescape(match.filename))
  vim.api.nvim_win_set_cursor(0, { match.lnum, math.max(0, match.col - 1) })
  vim.cmd("normal! zz")
  vim.notify("Jumped to definition of '" .. word .. "' in " .. vim.fs.basename(match.filename), vim.log.levels.INFO, { title = "Goto Definition" })
end

--- Present multiple candidates in Telescope
local function show_picker(matches, word, root)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  pickers.new({}, {
    prompt_title = "Definitions for '" .. word .. "' (including hidden folders)",
    finder = finders.new_table({
      results = matches,
      entry_maker = function(entry)
        local rel_path = nil
        if vim.fs.relpath then
          rel_path = vim.fs.relpath(root, entry.filename)
        end
        rel_path = rel_path or vim.fn.fnamemodify(entry.filename, ":.")
        return {
          value = entry,
          display = string.format("%s:%d  %s", rel_path, entry.lnum, entry.text),
          ordinal = entry.filename .. " " .. entry.text,
          filename = entry.filename,
          lnum = entry.lnum,
          col = entry.col,
        }
      end,
    }),
    previewer = conf.qflist_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

--- Smart Goto Definition (Ultra-fast, sub-20ms)
function M.goto_definition()
  local word = vim.fn.expand("<cword>")
  if not word or word == "" then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local is_verilog = (ft == "verilog" or ft == "systemverilog" or ft == "v" or ft == "sv" or ft == "vh" or ft == "svh")

  -- 1. INSTANT PATH: Check current buffer first (< 1ms, instant!)
  local local_match = search_current_buffer(bufnr, word, is_verilog)
  if local_match then
    local cur_lnum = vim.api.nvim_win_get_cursor(0)[1]
    if local_match.lnum ~= cur_lnum then
      jump_to(local_match, word)
      return
    end
  end

  local root = get_project_root(bufnr)

  -- 2. VERILOG / SYSTEMVERILOG FAST PATH:
  -- Runs targeted ~10ms ripgrep directly instead of waiting for slow LSP timeouts
  if is_verilog then
    local verilog_globs = { "*.v", "*.sv", "*.vh", "*.svh" }

    -- Tier 1: Module / Interface / Package / Class / Program
    local t1_pattern = [[\b(module|macromodule|interface|package|class|program)\s+]] .. word .. [[\b]]
    local matches = search_ripgrep(t1_pattern, root, verilog_globs)

    if #matches == 1 then
      jump_to(matches[1], word)
      return
    elseif #matches > 1 then
      show_picker(matches, word, root)
      return
    end

    -- Tier 2: Function / Task / Typedef / Macro define
    local t2_pattern = [[\b(function|task|typedef)\s+.*?\b]] .. word .. [[\b|^\s*`define\s+]] .. word .. [[\b]]
    matches = search_ripgrep(t2_pattern, root, verilog_globs)

    if #matches == 1 then
      jump_to(matches[1], word)
      return
    elseif #matches > 1 then
      show_picker(matches, word, root)
      return
    end

    -- Tier 3: Parameters, Nets, Ports, Logic
    local t3_pattern = [[\b(parameter|localparam|wire|reg|logic|bit|int|integer|genvar|input|output|inout)\s+.*?\b]] .. word .. [[\b]]
    matches = search_ripgrep(t3_pattern, root, verilog_globs)

    if #matches == 1 then
      jump_to(matches[1], word)
      return
    elseif #matches > 1 then
      show_picker(matches, word, root)
      return
    end
  end

  -- 3. STANDARD LSP PATH (for Python, Lua, Bash, C, etc. or if Verilog patterns weren't matched):
  local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
  local supports_def = false
  for _, client in ipairs(lsp_clients) do
    if client.supports_method("textDocument/definition") then
      supports_def = true
      break
    end
  end

  local function fallback_all()
    local globs = is_verilog and { "*.v", "*.sv", "*.vh", "*.svh" } or nil
    local pattern = [[\b]] .. word .. [[\b]]
    local matches = search_ripgrep(pattern, root, globs)

    if #matches == 0 then
      vim.notify("No definition found for '" .. word .. "' (searched all files & hidden folders)", vim.log.levels.WARN, { title = "Goto Definition" })
      return
    elseif #matches == 1 then
      jump_to(matches[1], word)
    else
      show_picker(matches, word, root)
    end
  end

  if not supports_def then
    fallback_all()
    return
  end

  -- Query LSP with a fast 150ms timeout
  local params = vim.lsp.util.make_position_params()
  local responded = false

  local timer = vim.defer_fn(function()
    if not responded then
      responded = true
      fallback_all()
    end
  end, 150)

  vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(err, result, ctx, config)
    if responded then
      return
    end
    responded = true
    pcall(function() timer:close() end)

    if not err and result and (not vim.tbl_isempty(result)) then
      if vim.islist(result) and #result == 0 then
        fallback_all()
      else
        vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
      end
    else
      fallback_all()
    end
  end)
end

return M
