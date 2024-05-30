-- TODO: check length of each section and calculate if need to trancate or not
-- local widget_len_obj = {}

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
-- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(key, trunc_width, trunc_len, hide_width)
    local no_ellipsis = false
    return function(str)
        -- widget_len_obj[key] = #str
        local win_width = vim.o.columns
        trunc_len = win_width * 0.2
        if hide_width and win_width < hide_width then
            return ""
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
        end
        return str
    end
end

-- 53:200/65 (81%)
local function ratio_progress()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local column = vim.fn.col(".")
    local line_ratio = current_line / total_lines * 100
    return string.format("󰉸 %d:%d/%d(%d%%%%)", current_line, column, total_lines, line_ratio)
end

local function lsp_clients()
    return require("lsp-progress").progress({
        format = function(messages)
            local active_clients = vim.lsp.get_active_clients({ bufnr = 0 })
            if #active_clients <= 0 then
                return ""
            else
                local client_name_list = {}
                for i, client in ipairs(active_clients) do
                    if client and client.name ~= "" and client.name ~= "null-ls" then
                        table.insert(client_name_list, client.name)
                    end
                end
                local win_width = vim.o.columns
                local lsp_count = " " .. #client_name_list
                local lsp_names = " " .. table.concat(client_name_list, ", ")
                -- INFO: if more than 20% of screen
                -- INFO: please note that "" is 3 characters long
                if win_width * 0.20 <= #lsp_names then
                    return lsp_count
                else
                    return lsp_names
                end
            end
        end,
    })
end

local function lsp_progress()
    return require("lsp-progress").progress({
        format = function(messages)
            return #messages > 0 and table.concat(messages, " ") or ""
        end,
    })
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        -- INFO: alternate plugin for displaying lsp progress
        -- "WhoIsSethDaniel/lualine-lsp-progress.nvim",
    },
    config = function()
        local lualine = require("lualine")
        lualine.setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            -- Available components:
            -- branch (git branch)
            -- buffers (shows currently available buffers)
            -- diagnostics (diagnostics count from your preferred source)
            -- diff (git diff status)
            -- encoding (file encoding)
            -- fileformat (file format)
            -- filename
            -- filesize
            -- filetype
            -- hostname
            -- location (location in file in line:column format)
            -- mode (vim mode)
            -- progress (%progress in file)
            -- searchcount (number of search matches when hlsearch is active)
            -- selectioncount (number of selected characters or lines)
            -- tabs (shows currently available tabs)
            -- windows (shows currently available windows)
            sections = {
                -- left:
                lualine_a = {
                    "mode",
                },
                lualine_b = {
                    {
                        "branch",
                        fmt = trunc("branch", 300, 50, 80),
                    },
                    {
                        "diff",
                        fmt = trunc("diff", nil, nil, 80),
                    },
                },
                lualine_c = {
                    "filename",
                },
                -- right:
                lualine_x = {
                    {
                        lsp_progress,
                        -- fmt = trunc(130, 13, 80, true),
                    },
                    -- INFO: "WhoIsSethDaniel/lualine-lsp-progress.nvim"
                    -- {
                    --     "lsp_progress",
                    --     separators = {
                    --         component = " ",
                    --         progress = " | ",
                    --         message = { pre = "(", post = ")" },
                    --         percentage = { pre = "", post = "%% " },
                    --         title = { pre = "", post = ": " },
                    --         lsp_client_name = { pre = "[", post = "]" },
                    --         spinner = { pre = "", post = "" },
                    --     },
                    --     -- by default this is false. If set to true will
                    --     -- only show the status of LSP servers attached
                    --     -- to the currently active buffer
                    --     only_show_attached = true,
                    --     display_components = { "lsp_client_name", "spinner" },
                    --     timer = {
                    --         progress_enddelay = 500,
                    --         spinner = 1000,
                    --         lsp_client_name_enddelay = 1000,
                    --         attached_delay = 3000,
                    --     },
                    --     -- spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
                    --     spinner_symbols = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
                    --     -- message = { initializing = 'Initializing…', commenced = 'In Progress', completed = 'Completed' },
                    --     max_message_length = 30,
                    -- },
                    "diagnostics",
                },
                lualine_y = {
                    {
                        lsp_clients,
                    },
                    {
                        "filetype",
                        fmt = trunc("filetype", nil, nil, 80, false),
                    },
                },
                lualine_z = {
                    ratio_progress,
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        })
    end,
}
