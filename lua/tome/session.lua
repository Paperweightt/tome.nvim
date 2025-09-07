local M = {}
local parse_note = require("tome.pages").parse_body
local edit_page = require("tome.pages").edit_page
local get_id = require("tome.pages").get_next_id

function M.parse_file(filepath)
  filepath = vim.fn.expand(filepath)

  local file, err = io.open(filepath, "r")
  local lines = {}

  if not file then
    vim.notify("Error reading file: " .. err, vim.log.levels.ERROR)
    return
  end

  for line in file:lines() do
    table.insert(lines, line)
  end

  file:close()

  local pages = {}
  local raw_pages = M.split_session(lines)

  for _, raw_page in pairs(raw_pages) do
    local page = parse_note(raw_page)
    table.insert(pages, page)
  end

  return pages
end

function M.split_session(lines)
  local pages = {}

  local function add_page(start, _end)
    local page = {}
    for i = start, _end do
      table.insert(page, lines[i])
    end
    table.insert(pages, page)
  end

  local start = 1
  local _end = 1
  local found_first_page = false

  for i = 1, #lines do
    local line = lines[i]

    if found_first_page == false then
      if line:match("^# ") then
        start = i
      else
        found_first_page = true
      end
      goto next_iteration
    end

    if line:match("^# ") or i == #lines then
      add_page(start, _end)
      start = i
    end

    if line:match("^$") or line:match("^%-%-%-") then
      goto next_iteration
    else
      _end = i
    end

    ::next_iteration::
  end

  return pages
end

function M.add_ids_to_bufr(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    local has_id = line:match("^# (.-) <!%-%-(.-)%-%->$")
    local has_title = line:match("^# (.-)$")

    if has_title and not has_id then
      lines[i] = line .. " <!--" .. get_id() .. "-->"
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

function M.save_session(filepath)
  local pages = M.parse_file(filepath)

  if not pages then
    return
  end

  for _, page in pairs(pages) do
    edit_page(page.id, page.lines)
  end
end

function M.find_page(session_filepath, page_id)

end

return M
