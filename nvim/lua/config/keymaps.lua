-- Add any keymaps that aren't related to a plugin here

-- This is set in root init.lua since it needs to be set before lazy
-- vim.g.mapleader = " "

-- Open netrw
vim.keymap.set("n", "<leader>f", ":Oil<CR>")

-- Move line up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--Center after moving up or down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--Toggle diagnostics
vim.keymap.set("n", "gl", ":lua vim.diagnostic.open_float()<CR>")

