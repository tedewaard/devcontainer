return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        -- Set up any telescope configuration here if needed
        --
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "Find Files" })
        vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "Find git files" })
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = "Live grep for string" })
        vim.keymap.set('n', '<leader>sw', function()
            builtin.find_files({
                cwd = "~/wiki",
            })
            end, { desc = "Find files in wiki directory"})
    end,
}
