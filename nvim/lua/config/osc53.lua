-- clipboard-osc52.lua
-- Add this to your neovim config (init.lua or as a separate file in lua/)
--
-- OSC 52 clipboard support for use inside containers/SSH.
-- This makes yank (y) and paste (p) work with your system clipboard
-- even though the container has no display server.
--
-- HOW IT WORKS:
-- When you yank text, neovim sends a special escape sequence (OSC 52)
-- through the terminal. Your terminal emulator (Windows Terminal, Kitty,
-- Alacritty, iTerm2, etc.) recognizes this sequence and copies the text
-- to your system clipboard. Paste still comes from your terminal's
-- Ctrl+Shift+V (or Cmd+V on Mac).
--
-- REQUIREMENTS:
-- - Neovim 0.10+ (has built-in OSC 52 support)
-- - A terminal that supports OSC 52 (most modern ones do)
--
-- If you're on neovim 0.10+, it auto-detects OSC 52 in most cases.
-- This config just makes it explicit and adds a fallback.

-- Check if we're running in a container (no display server available)
local function is_container()
  -- Common signals that we're inside a container
  return os.getenv("container") ~= nil
    or vim.fn.filereadable("/.dockerenv") == 1
    or vim.fn.filereadable("/run/.containerenv") == 1
end

if is_container() or os.getenv("SSH_TTY") ~= nil then
  -- Force OSC 52 clipboard provider
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      -- Paste via OSC 52 can be unreliable, so we leave it empty.
      -- Use your terminal's paste (Ctrl+Shift+V / Cmd+V) instead.
      -- If your terminal supports OSC 52 paste, uncomment below:
      -- ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      -- ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      ["+"] = "",
      ["*"] = "",
    },
  }
end
