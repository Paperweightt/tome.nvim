local M = {}
local pages = require("tome.pages")
local session = require("tome.session")
local snippets = require("tome.autocomplete")

vim.api.nvim_create_user_command("TomePrintPages", function()
  vim.print(pages.get_pages())
end, {})

vim.api.nvim_create_user_command("TomeAddSnippets", function()
  snippets.refresh()
end, {})

vim.api.nvim_create_user_command("TomeSave", function()
  session.save_session(vim.api.nvim_buf_get_name(0))
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
