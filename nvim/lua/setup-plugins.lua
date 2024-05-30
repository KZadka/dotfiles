local command = "sh ~/.config/nvim/setup.sh"
-- os.execute(command)
print("Checking if python global venv exists...")
local handle = io.popen(command)
local result = handle:read("*a")
print(result)
handle:close()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}
for _, dir in ipairs({ "plugins", "lsp" }) do
	for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/" .. dir, [[v:val =~ '\.lua$']])) do
		local plugin = require(dir .. "." .. file:gsub("%.lua$", ""))
		table.insert(plugins, plugin)
	end
end
require("lazy").setup(plugins, {})
