local M = {}

M.defaults = {
}

M.options = {}

function M.setup(user_config)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, user_config or {})
end

return M
