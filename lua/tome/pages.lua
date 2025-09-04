local M = {}

M.get_pages = function()
  local page = {}

  -- TODO: fix with adjustable path
  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)

  for _, file in ipairs(scan) do
    local lines = vim.fn.readfile(file)
    local id = lines[1]:match("<!%-%-id:(.-)%-%->")
    local title = lines[1]:match("^(.-) <!--")

    if not id then
      goto next_iteration
    end

    table.insert(page, {
      lines = lines,
      title = title,
      id = id,
      -- last_edit=,
      -- date=
    })

    ::next_iteration::
  end

  return page
end

M.parse_header = function(header)

end

M.parse_body = function(body)
  local id = body[1]:match("<!%-%-id:(.-)%-%->")
  local title = body[1]:match("^(.-) <!--")

  return {
    lines = body,
    title = title,
    id = id,
  }
end

M.get_next_id = function()
  local timestamp = os.date("%Y-%m-%d")
  local highest_id = 0

  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)

  for _, file_name in ipairs(scan) do
    local id = file_name:match("-(%d+)%.md$")

    highest_id = math.max(highest_id, id)
  end

  return timestamp .. "-" .. highest_id + 1
end

M.new_page = function(lines)
  local id = M.get_next_id()
  local filename = lines[1]:sub(3) .. "__" .. id .. ".md"
  local path = vim.fn.expand("~/Notes/tome/pages/" .. filename)

  lines[1] = lines[1] .. " <!--" .. id .. "-->"

  local file, err = io.open(path, "w")
  if not file then
    vim.notify("Error creating file: " .. err, vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(lines, "\n"))

  file:close()
end

M.edit_page = function(id, lines)
  local path = M.get_filepath(id)
  vim.print(path)

  if path == nil then
    vim.notify("Error editing file does not exist: " .. path, vim.log.levels.ERROR)
    return
  end

  local old_lines = vim.fn.readfile(path)
  local old_page = M.parse_body(old_lines)
  local new_page = M.parse_body(lines)


  if old_page.title ~= new_page.title then
    vim.print("title changed")
    local filename = new_page.title:sub(3) .. "__" .. id .. ".md"

    path = vim.fn.fnamemodify(path, ":h") .. "/" .. filename
    -- vim.print(vim.fn.fnamemodify(path, ":h") .. "/" .. filename)
  end

  local file, err = io.open(path, "w")
  if not file then
    vim.notify("Error creating file: " .. err, vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(lines, "\n"))

  file:close()
end

M.get_filepath = function(id)
  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)

  for _, file_name in ipairs(scan) do
    vim.print(file_name:match("__(.-)%.md$"))
    if id == file_name:match("__(.-)%.md$") then
      return file_name
    end
  end

  return nil
end

M.edit_page("2025-09-03-4", {
  "# whaterest2 <!--2025-09-03-4-->",
  "",
  "there",
  "was",
  "a",
  "change"
})

return M
