local M = {}

M.get_pages = function()
  local pages = {}

  -- TODO: fix with adjustable path
  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)

  for _, file in ipairs(scan) do
    local lines = vim.fn.readfile(file)
    local id = lines[1]:match("<!%-%-(.-)%-%->")
    local title = lines[1]:match("^(.-) <!--")

    if not id then
      goto next_iteration
    end

    table.insert(pages, {
      lines = lines,
      title = title,
      id = id,
      -- last_edit=,
      -- date=
    })

    ::next_iteration::
  end

  return pages
end

M.parse_header = function(header)

end

M.parse_body = function(body)
  local id = body[1]:match("<!%-%-(.-)%-%->")
  local title = body[1]:match("^(.-) <!--")

  return {
    lines = body,
    title = title,
    id = id,
  }
end

local id

M.get_next_id = function()
  local timestamp = os.date("%Y-%m-%d")
  local new_id = 0

  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)

  if id == nil then
    for _, file_name in ipairs(scan) do
      local file_id = file_name:match("-(%d+)%.md$")

      new_id = math.max(new_id, file_id)
    end
    id = new_id + 1
  else
    id = id + 1
    new_id = id
  end

  return timestamp .. "-" .. new_id
end

M.new_page = function(lines)
  local page = M.parse_body(lines)
  local filename = page.title:sub(3) .. "__" .. page.id .. ".md"
  local path = vim.fn.expand("~/Notes/tome/pages/" .. filename)

  local file, err = io.open(path, "w")
  if not file then
    vim.notify("Error creating file: " .. err, vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(lines, "\n"))
  file:close()
end

local function arrays_equal(a, b)
  -- Different lengths? Not equal
  if #a ~= #b then
    return false
  end

  -- Compare element by element
  for i = 1, #a do
    if a[i] ~= b[i] then
      return false
    end
  end

  return true
end

-- TODO: sync with buffers (if a page buffer is already opened it should be reopened)
M.edit_page = function(id, lines)
  local path = M.get_filepath(id)

  if path == nil then
    M.new_page(lines)
    vim.print("new page: " .. lines[1])
    return
  end

  local old_lines = vim.fn.readfile(path)

  if arrays_equal(old_lines, lines) then
    return
  end

  vim.print("edit page: " .. lines[1])

  local old_page = M.parse_body(old_lines)
  local new_page = M.parse_body(lines)

  local file, err = io.open(path, "w")
  if not file then
    vim.notify("Error creating file: " .. err, vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(lines, "\n"))

  file:close()

  if old_page.title ~= new_page.title then
    -- TODO: check if this works in linux
    local filename = new_page.title:sub(3) .. "__" .. id .. ".md"
    local new_path = vim.fn.fnamemodify(path, ":h") .. "/" .. filename
    local success, err_message = os.rename(path, new_path)

    if not success then
      vim.notify("Error renaming file: " .. err_message, vim.log.levels.ERROR)
    end
  end
end

M.get_filepath = function(id)
  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)

  for _, file_name in ipairs(scan) do
    if id == file_name:match("__(.-)%.md$") then
      return file_name
    end
  end

  return nil
end

return M
