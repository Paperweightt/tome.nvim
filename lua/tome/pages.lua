local M = {}

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

return M
