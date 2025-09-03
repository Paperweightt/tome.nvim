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

M.get_next_id = function()
  local timestamp = os.date("%Y-%m-%d")

  return timestamp .. "-" .. 1
end

M.new_page = function(lines)
  local id = M.get_next_id()
  local filename = lines[1]:sub(3) .. "__" .. id .. ".md"
  local path = vim.fn.expand("~/Notes/tome/pages/" .. filename)

  lines[1] = lines[1] .. " <!--" .. id .. "-->"

  local file, err = io.open(path, "w") -- "w" creates or overwrites
  if not file then
    vim.notify("Error creating file: " .. err, vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(lines, "\n"))

  file:close()
end

M.edit_page = function(id, lines)

end

M.new_page({
  "# hitest5",
  "this is a test",
  "hellooo"
})

return M
