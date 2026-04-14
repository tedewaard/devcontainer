vim.g.mapleader = " " -- Make sure to set 'mapleader' before lazy so your mappings are correct
require("config.options")
require("config.lazy")

-- Not fully confident in how this autocmd gets triggered
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("config.autocmds")
        require("config.keymaps")
        require("config.journal")
    end,
})

local lsp_configs = {
}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)
