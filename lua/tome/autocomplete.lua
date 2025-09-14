local source = {}
local tome_pages = require("tome.pages")

local function buf_needs_pre_divider(bufnr)
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_number, false)

  for i = #lines, 1, -1 do
    local line = lines[i]

    if not line:match("^$") then
      return not line:match('^---')
    end
  end

  return false
end

local function buf_needs_post_divider(bufnr)
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, line_number, -1, false)

  for _, line in ipairs(lines) do
    if not line:match("^$") then
      return not line:match('^---')
    end
  end

  return false
end

local function get_new_text(page)
  local inputs = {}
  local line = vim.api.nvim_get_current_line()
  local bufnr = vim.api.nvim_get_current_buf()

  if line:match("^# ") then
    local header = string.sub(page.lines[1], 3)
    local content = { header }
    for index = 2, #page.lines do
      table.insert(content, page.lines[index])
    end

    inputs = content
  else
    inputs = vim.list_slice(page.lines)
  end

  if buf_needs_pre_divider(bufnr) then
    table.insert(inputs, 1, ' ')
    table.insert(inputs, 1, '---')
  end

  if buf_needs_post_divider(bufnr) then
    table.insert(inputs, '')
    table.insert(inputs, '---')
  end

  return inputs
end


function source.new(opts)
  local self = setmetatable({}, { __index = source })

  -- self.opts = vim.tbl_extend("force", default_opts, opts)
  -- self:_validate_config()
  return self
end

function source:get_completions(ctx, callback)
  if string.sub(ctx.line, -1, -1) ~= "#" then
    return callback({
      items = {},
      is_incomplete_backward = true,
      is_incomplete_forward = false,
    })
  end


  ---@type lsp.CompletionItem[]
  self.items = {}

  for _, page in pairs(tome_pages.get_pages()) do
    page.label = page.title
    page.textEdit = {
      newText = table.concat(get_new_text(page), "\n"),
      kind = "Text",
      range = {
        start = {
          line = ctx.bounds.line_number - 1,
          character = ctx.bounds.start_col - 2,
        },
        ["end"] = {
          line = ctx.bounds.line_number - 1,
          character = ctx.bounds.start_col - 1,
        },
      },
    }
    table.insert(self.items, page)
  end

  callback({
    items = self.items,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })
end

return source
