local M = {}

function M.parse_file(filepath)
  local file, err = io.open(filepath, "r")
  local lines = {}
  local pages = {}

  filepath = vim.fn.expand(filepath)

  if not file then
    vim.notify("Error reading file: " .. err, vim.log.levels.ERROR)
    return
  end

  for line in file:lines() do
    table.insert(lines, line)
  end

  file:close()

  local function add_page(start, _end)
    local page = {}
    for i = start, _end do
      table.insert(lines[i])
    end
    table.insert(page)
  end

  local start = 1
  local _end = 1

  for i = 1, #lines do
    local line = lines[i]

    if not line:match("^$") then
      _end = i
    end

    if line:match("^# ") then
      start = i
    end

    add_page(start, _end)
  end

  return pages
end

M.parse_file("")

function M.find_page(session_filepath, page_id)

end

return M
