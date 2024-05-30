local opt = vim.opt
local api = vim.api

-- prevent 'deprecate' check
vim.deprecate = function () end

-- line numbers
opt.relativenumber = true
opt.number = true
opt.scrolloff = 7
opt.colorcolumn = "80"

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- split windows
opt.splitright = false
opt.splitbelow = true

opt.iskeyword:append("-")

-- remove trailing  whitespace
api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

-- disable swapfile
opt.swapfile = false

-- restore last position when opening a file
api.nvim_create_autocmd({ "BufWinEnter" }, {
	desc = "return cursor to where it was last time closing the file",
	pattern = "*",
	command = 'silent! normal! g`"zv',
})

-- set global venv for python
PYTHON_VENV_DIR = '~/.config/.nvim-venv/bin/python'
vim.g.python_host_prog = PYTHON_VENV_DIR
vim.g.python3_host_prog = PYTHON_VENV_DIR
