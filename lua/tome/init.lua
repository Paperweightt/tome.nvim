local M = {}
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node

ls.config.setup({ enable_autosnippets = true })

vim.api.nvim_create_user_command("Tome AddSnippets", function()
  M.add_snippets()
end, {})

vim.api.nvim_create_user_command("Tome PrintPages", function()
  vim.print(M.get_pages())
end, {})

M.get_pages = function()
  local page = {}

  -- TODO: fix with adjustable path
  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)


  for _, file in ipairs(scan) do
    local lines = vim.fn.readfile(file)
    -- local title = lines[1]:gsub("^#%s*", "") -- assumes first line is "# Title"
    -- local id = nil

    table.insert(page, {
      lines = lines,
      title = lines[1]
      -- id = ,
      -- last_edit=,
      -- date=
    })
  end

  return page
end

local function buf_needs_pre_divider(bufnr)
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_number, false)

  for index = #lines, 1, -1 do
    local line = lines[index]

    if not line:match("^$") then
      return not line:match('^---')
    end
  end

  return true
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
  local pages = M.get_pages()

  for _, page in pairs(pages) do
    ls.add_snippets("markdown", {
      s({
        trig = page.title,
        snippetType = "autosnippet",
        docstring = "hi hello there"
      }, {
        f(input_page(page))
      }),
    })
  end
end

M.add_snippets()

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "notes/pages/*.md",
  callback = function()
    ls.invalidate("markdown")
    M.add_snippets()
  end,
})

return M
