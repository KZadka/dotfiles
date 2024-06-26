return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        -- {
        --     "nvim-telescope/telescope-live-grep-args.nvim",
        --     -- This will not install any breaking changes.
        --     -- For major updates, this must be adjusted manually.
        --     version = "^1.0.0",
        -- },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")
        local transform_mod = require("telescope.actions.mt").transform_mod
        local action_state = require("telescope.actions.state")

        -- Telescope multi-selection --
        local function multiopen(prompt_bufnr, method)
            local edit_file_cmd_map = {
                vertical = "vsplit",
                horizontal = "split",
                tab = "tabedit",
                default = "edit",
            }
            local edit_buf_cmd_map = {
                vertical = "vert sbuffer",
                horizontal = "sbuffer",
                tab = "tab sbuffer",
                default = "buffer",
            }
            local picker = action_state.get_current_picker(prompt_bufnr)
            local multi_selection = picker:get_multi_selection()

            if #multi_selection > 1 then
                require("telescope.pickers").on_close_prompt(prompt_bufnr)
                pcall(vim.api.nvim_set_current_win, picker.original_win_id)

                for i, entry in ipairs(multi_selection) do
                    local filename, row, col

                    if entry.path or entry.filename then
                        filename = entry.path or entry.filename

                        row = entry.row or entry.lnum
                        col = vim.F.if_nil(entry.col, 1)
                    elseif not entry.bufnr then
                        local value = entry.value
                        if not value then
                            return
                        end

                        if type(value) == "table" then
                            value = entry.display
                        end

                        local sections = vim.split(value, ":")

                        filename = sections[1]
                        row = tonumber(sections[2])
                        col = tonumber(sections[3])
                    end

                    local entry_bufnr = entry.bufnr

                    if entry_bufnr then
                        if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
                            vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
                        end
                        local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
                        pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
                    else
                        local command = i == 1 and "edit" or edit_file_cmd_map[method]
                        if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
                            filename =
                                require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
                            pcall(vim.cmd, string.format("%s %s", command, filename))
                        end
                    end

                    if row and col then
                        pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
                    end
                end
            else
                actions["select_" .. method](prompt_bufnr)
            end
        end

        local custom_actions = transform_mod({
            multi_selection_open_vertical = function(prompt_bufnr)
                multiopen(prompt_bufnr, "vertical")
            end,
            multi_selection_open_horizontal = function(prompt_bufnr)
                multiopen(prompt_bufnr, "horizontal")
            end,
            multi_selection_open_tab = function(prompt_bufnr)
                multiopen(prompt_bufnr, "tab")
            end,
            multi_selection_open = function(prompt_bufnr)
                multiopen(prompt_bufnr, "default")
            end,
        })

        local function stopinsert(callback)
            return function(prompt_bufnr)
                -- vim.cmd.stopinsert()
                vim.cmd("stopinsert")
                vim.schedule(function()
                    callback(prompt_bufnr)
                end)
            end
        end

        local multi_open_mappings = {
            i = {
                ["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
                ["<C-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
                ["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
                ["<CR>"] = stopinsert(custom_actions.multi_selection_open),
            },
            n = {
                ["<C-v>"] = custom_actions.multi_selection_open_vertical,
                ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
                ["<C-t>"] = custom_actions.multi_selection_open_tab,
                ["<CR>"] = custom_actions.multi_selection_open,
            },
        }

        telescope.setup({
            extensions = {
                fzf = {
                    fuzzy = true,    -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
            pickers = {
                colorscheme = {
                    enable_preview = true,
                },
                oldfiles = {
                    mappings = multi_open_mappings,
                },
                find_files = {
                    follow = true,
                    mappings = multi_open_mappings,
                },
                buffers = {
                    sort_mru = true,
                    mappings = multi_open_mappings,
                },
            },
        })
        telescope.load_extension("fzf")

        -- MVP: grep imitiating fuzzy search
        -- used in keymaps
        function fuzzyFindFiles()
            builtin.grep_string({
                path_display = { "smart" },
                only_sort_text = true,
                word_match = "-w",
                search = "",
            })
        end
    end,
}
