local M = {}

M.get_pages = function()
  local page = {}

  -- TODO: fix with adjustable path
  local scan = vim.fn.glob("~/Notes/tome/pages/*.md", false, true)


  for _, file in ipairs(scan) do
    local lines = vim.fn.readfile(file)
    local id = lines[1]:match("<!%-%-id:(.-)%-%->")
    local title = lines[1]:match("^(.-) <!--")

    table.insert(page, {
      lines = lines,
      title = title,
      id = id,
      -- last_edit=,
      -- date=
    })
  end

  return page
end

return M
