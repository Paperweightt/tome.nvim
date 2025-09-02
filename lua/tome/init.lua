local M = {}
local pages = require("tome.pages")
local snippets = require("tome.autocomplete")

vim.api.nvim_create_user_command("Tome PrintPages", function()
  vim.print(pages.get_pages())
end, {})

vim.api.nvim_create_user_command("Tome AddSnippets", function()
  snippets.refresh()
end, {})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "notes/pages/*.md",
  callback = function()
    snippets.refresh()
  end,
})

snippets.add_snippets()

return M
