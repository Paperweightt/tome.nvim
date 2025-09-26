local session = require("tome.session")
local config = require("tome.config").options

vim.api.nvim_create_user_command("TomeSave", function()
  session.add_missing_ids(0)
  vim.cmd("write")
  session.save_session(0)
end, {})

vim.api.nvim_create_user_command("TomeFormatIds", function()
  session.add_missing_ids(0)
  vim.cmd("write")
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = vim.fn.expand(config.tome_path) .. "**/*.md",
  callback = function(args)
    session.add_missing_ids(args.buf)
  end,
})


vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand(config.tome_path) .. "**/*.md",
  callback = function(args)
    session.save_session(args.buf)
  end,
})
