local M = {}
local tome_pages = require("tome.pages")
local ls = require("luasnip")

local s = ls.snippet
local f = ls.function_node

ls.config.setup({ enable_autosnippets = true })

local function buf_needs_pre_divider(bufnr)
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_number, false)

  for i = #lines, 1, -1 do
    local line = lines[i]

    if not line:match("^$") then
      vim.print(line)
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

local function input_page(page)
  return function()
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
end

M.add_snippets = function()
  local pages = tome_pages.get_pages()

  for _, page in pairs(pages) do
    ls.add_snippets("markdown", {
      s({
        trig = page.title .. " " .. page.id,
        snippetType = "autosnippet",
        -- docstring = "hi hello there"
      }, {
        f(input_page(page))
      }),
    })
  end
end

M.refresh = function()
  ls.invalidate("markdown")
  M.add_snippets()
end

return M
