local session = require("tome.session")
local config = require("tome.config").options

vim.api.nvim_create_user_command("TomeSave", function()
  local bufr = vim.api.nvim_bug_get_name(0)
  session.add_missing_ids(bufr)
  session.save_session(bufr)
end, {})

vim.api.nvim_create_user_command("TomeFormatIds", function()
  session.add_missing_ids(0)
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = vim.fn.expand(config.tome_path) .. "**/*.md",
  callback = function(args)
    session.add_missing_ids(args.buf)
    session.save_session(args.buf)
  end,
})
