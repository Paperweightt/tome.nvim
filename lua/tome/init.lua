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
  local bufr = vim.api.nvim_bug_get_name(0)
  session.add_ids_to_bufr(bufr)
  session.save_session(bufr)
  snippets.refresh()
end, {})

vim.api.nvim_create_user_command("TomeFormatIds", function()
  session.add_missing_ids()
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function(args)
    session.add_ids_to_bufr(args.buf)
    session.save_session(vim.api.nvim_buf_get_name(0))
    -- snippets.refresh()
  end,
})


-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "notes/pages/*.md",
--   callback = function()
--     snippets.refresh()
--   end,
-- })

snippets.add_snippets()

return M
