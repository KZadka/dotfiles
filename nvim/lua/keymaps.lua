local wk = require("which-key")

local function toggle_blame_file()
    local buffer_list = vim.api.nvim_list_bufs()
    for key, value in pairs(buffer_list) do
        local buf_name = vim.api.nvim_buf_get_name(value)
        if string.find(buf_name, 'fugitiveblame') then
            vim.api.nvim_buf_delete(value, {})
            return
        end
    end
    vim.cmd("Git blame")
end

wk.register({
    z = { name = "folds" },
    ["<C-S-G>"] = {
        "<cmd>echo expand('%:p') . ' +' . line(\".\")<CR>",
        "Show current path with line number",
    },
    ["<C-\\>"] = { "<cmd>Lspsaga term_toggle<CR>", "Terminal (toggle)" },
    ["<ESC>"] = { "<cmd>nohlsearch<CR>", "No search highlight" },
    ["]c"] = { "<cmd>Gitsigns next_hunk<CR>", "Next hunk" },
    ["[c"] = { "<cmd>Gitsigns prev_hunk<CR>", "Prev hunk" },
    ["]t"] = {
        "<cmd>lua require('todo-comments').jump_next()<CR>",
        "Next TODO",
    },
    ["[t"] = {
        "<cmd>lua require('todo-comments').jump_prev()<CR>",
        "Previous TODO",
    },
    -- Lsp things too common to be grouped
    K = { "<cmd>Lspsaga hover_doc<CR>", "Hover doc" },
    ["gd"] = { "<cmd>Lspsaga goto_definition<CR>", "Go to definition" },
    ["gr"] = { "<cmd>Lspsaga finder<CR>", "Go to references/implementation" },
    ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostics" },
    ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous diagnostics" },
}, {
    mode = "n",
})

-- leader + ...
wk.register({
    [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
    [","] = { "<cmd>Telescope buffers<CR>", "Search in open buffers" },
    ["?"] = { "<cmd>e ~/.config/nvim/SHORTCUTS.md<CR>", "Help me!"},
    c = { "<cmd>bd<CR>", "Close buffer" },
    e = { "<cmd>NvimTreeFindFileToggle<CR>", "File explorer" },
    f = { "<cmd>Telescope find_files<CR>", "Find files" },
    g = {
        name = "git",
        b = { toggle_blame_file, "Blame file" },
        -- B = { "<cmd>Telescope git_branches<CR>", "Branches" },
        c = { "<cmd>Telescope git_commits<CR>", "Commits" },
        C = { "<cmd>Telescope git_bcommits<CR>", "Commits (for current file)" },
        d = { "<cmd>Gitsigns diffthis HEAD<CR>", "Diff current file" },
        D = { "<cmd>Gitsigns diffthis rc<CR>", "Diff current file (rc)" },
        h = {
            name = "hunks",
            r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
            s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
            p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
            u = {
                "<cmd>Gitsigns undo_stage_hunk<CR>",
                "Undo stage hunk",
            },
        },
        l = { "<cmd>Git log<CR>", "Log" },
        R = { "<cmd>Gitsigns reset_buffer<CR>", "Reset buffer" },
        s = { "<cmd>Telescope git_status<CR>", "Status" },
        S = { "<cmd>Gitsigns stage_buffer<CR>", "Stage buffer" },
        t = { "<cmd>Git difftool<CR>", "Difftool" },
        T = { "<cmd>Git difftool rc<CR>", "Difftool (rc)" },
    },
    i = {
        name = "info",
        c = { "<cmd>checkhealth<CR>", "Checkhealth" },
        i = { "<cmd>LspInfo<CR>", "LSP info" },
        l = { "<cmd>Lazy<CR>", "Lazy" },
        m = { "<cmd>messages<CR>", "Messages" },
        M = { "<cmd>Mason<CR>", "Mason" },
        -- u = { "<cmd>Lazy update<CR>", "Update plugins" },
    },
    -- j = { "<cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
    -- k = { "<cmd>Gitsigns prev_hunk<CR>", "Prev Hunk" },
    l = {
        name = "lsp actions",
        a = { "<cmd>Lspsaga code_action<CR>", "Code action" },
        f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format file" },
        l = {
            "<cmd>lua vim.diagnostic.open_float()<CR>",
            "Show diagnostics for current line",
        },
        o = { "<cmd>Lspsaga outline<CR>", "Show symbols outline" },

        p = { "<cmd>Lspsaga peek_definition<CR>", "Peek definition" },
        r = { "<cmd>Lspsaga rename<CR>", "Rename" },
    },
    q = { "<cmd>qa<CR>", "Quit" },
    Q = { "<cmd>qa!<CR>", "Force quit" },
    -- r =
    s = {
        name = "search",
        -- a = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Live grep args" },
        b = { "<cmd>Telescope buffers<CR>", "Search open buffers" },
        c = { "<cmd>Telescope colorscheme<CR>", "Search colorschemes" },
        d = { "<cmd>Telescope diagnostics<CR>", "Search diagnostics" },
        f = { "<cmd>Telescope find_files<CR>", "Search files" },
        g = { "<cmd>Telescope git_files<CR>", "Search git files" },
        h = { "<cmd>Telescope command_history<CR>", "Search command history" },
        k = { "<cmd>Telescope keymaps<CR>", "Search keymaps" },
        l = { "<cmd>Telescope lsp_document_symbols<CR>", "Search document symbols (LSP)" },
        L = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Search workspace symbols (LSP)" },
        o = { "<cmd>Telescope oldfiles<CR>", "Search recently opened files" },
        r = { "<cmd>Telescope resume<CR>", "Resume last search" },
        s = { "<cmd>lua fuzzyFindFiles{}<cr>", "Fuzzy search" },
        S = { "<cmd>Telescope live_grep<CR>", "Search text (grep)" },
        t = { "<cmd>TodoTelescope<CR>", "Search TODOs" },
        c = { "<cmd>Telescope<CR>", "Telescope" },
        w = { "<cmd>Telescope grep_string<CR>", "Search word under cursor (grep)" },
    },
    u = {
        name = "ui",
        b = { "<cmd>Gitsigns blame_line<CR>", "Git blame show" },
        B = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Git blame (toggle)" },
        d = {
            "<cmd>call v:lua.toggle_inline_diagnostics()<CR>",
            -- "<cmd>lua require(\"lsp_lines\").toggle()<CR>",
            "Hide inline diagnostics (toggle)",
        },
        D = {
            "<cmd>call v:lua.toggle_diagnostics()<CR>",
            "Diagnostics (toggle)",
        },
        g = { "<cmd>Gitsigns toggle_linehl<CR>", "Git line highlight (toggle)" },
        n = { "<cmd>set number!<CR>", "Line numbers (toggle)" },
        N = { "<cmd>set relativenumber!<CR>", "Relative line numbers (toggle)" },
        r = { "<cmd>syntax sync fromstart<CR>", "Reload syntax highlighting" },
        w = { "<cmd>set wrap!<CR>", "Line wrapping (toggle)" },
    },
    w = { "<cmd>w!<CR>", "Write" },
    W = { "<cmd>wa!<CR>", "Write all" },
    x = { "<cmd>xa<CR>", "Save & quit" },
    X = { "<cmd>xa!<CR>", "Force save & quit" },
}, {
    prefix = "<leader>",
    mode = "n",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
})

wk.register({
    ["<C-\\>"] = { "<C-\\><C-n><cmd>Lspsaga term_toggle<CR>", "Terminal (toggle)" },
}, {
    mode = "t",
})

function set_filetype_keymaps()
    local fileTy = vim.api.nvim_buf_get_option(0, "filetype")
    if fileTy == "python" then
        wk.register({
            ["<leader>f"] = {
                ":'<,'>!~/.config/.nvim-venv/bin/python3 -m macchiato --line-length 80 -S<CR>",
                "Format selection (python)",
                mode = "v",
            },
            -- INFO: not needed - done by ruff's code actions
            -- ["<leader>lF"] = {
            --     "<cmd>PyrightOrganizeImports<CR>",
            --     "Organize imports (Python)",
            --     mode = "n",
            -- },
        })
    end
end

vim.cmd("autocmd FileType * lua set_filetype_keymaps()")

local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--  noemal_mode = "n"
--  insert_mode = "i"
--  visual_mode = "v"
--  visual_block_mode = "x"
--  term_mode = "t"
--  command_mode = "c"

-- Normal
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "XXX", opts)
keymap("n", "<C-l>", "XYX", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize window
keymap("n", "<A-LEFT>", ":vertical resize -5<CR>", opts)
keymap("n", "<A-RIGHT>", ":vertical resize +5<CR>", opts)
keymap("n", "<A-UP>", ":horizontal resize +5<CR>", opts)
keymap("n", "<A-DOWN>", ":horizontal resize -5<CR>", opts)
keymap("n", "<A-h>", ":vertical resize -5<CR>", opts)
keymap("n", "<A-l>", ":vertical resize +5<CR>", opts)
keymap("n", "<A-j>", ":horizontal resize +5<CR>", opts)
keymap("n", "<A-k>", ":horizontal resize -5<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text
keymap("n", "<C-A-j>", ":m .+1<CR>", opts)
keymap("n", "<C-A-k>", ":m .-2<CR>", opts)

-- Make x not copy
keymap("n", "x", '"_x', opts)

-- Visual
-- Stay in visual mode after changing indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
-- Move text
keymap("v", "<C-A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-A-k>", ":m '<-2<CR>gv=gv", opts)

-- Insert
-- Delete whole word in insert mode
keymap("i", "<C-H>", "<C-W>", opts) -- ctrl+backspace
