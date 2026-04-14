-- Daily Journal Function in Lua

-- Function to open daily journal and add timestamped entry
local function open_daily_journal()
  -- Set the wiki directory path - modify this to match your actual path
  local wiki_dir = vim.fn.expand('~/wiki/journal/')
  
  -- Create the journal directory if it doesn't exist
  if vim.fn.isdirectory(wiki_dir) == 0 then
    vim.fn.mkdir(wiki_dir, 'p')
  end
  
  -- Format the filename as YYYY-MM-DD.md
  local filename = os.date('%Y-%m-%d') .. '.md'
  local filepath = wiki_dir .. filename
  
  -- Open or create the daily journal file
  vim.cmd('edit ' .. filepath)
  
  -- If the file is new (empty), add a header
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
    local header = '# Journal: ' .. os.date('%A, %B %d, %Y')
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {header, ''})
    vim.api.nvim_win_set_cursor(0, {3, 0})
  end
  
  -- Move to the end of the file
  vim.cmd('normal! G')
  
  -- If we're not at an empty line, add one
  if vim.fn.getline('.') ~= '' then
    local last_line = vim.fn.line('$')
    vim.api.nvim_buf_set_lines(0, last_line, last_line, false, {''})
    vim.cmd('normal! G')
  end
  
  -- Add the timestamp and position cursor for entry
  local timestamp = '## ' .. os.date('%H:%M')
  local last_line = vim.fn.line('$')
  vim.api.nvim_buf_set_lines(0, last_line, last_line, false, {timestamp, ''})
  vim.cmd('normal! G')
  
  -- Enter insert mode ready to type
  vim.cmd('startinsert')
end

-- Create a command to call the function
vim.api.nvim_create_user_command('Journal', function()
  open_daily_journal()
end, {})

-- Optional: Create a keyboard mapping (e.g., <Leader>j)
vim.api.nvim_set_keymap('n', '<Leader>j', ':Journal<CR>', {noremap = true, silent = true})
