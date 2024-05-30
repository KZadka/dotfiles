-- Inline diagnostics --

local inline_diagnostics_active = true

function _G.toggle_inline_diagnostics()
    inline_diagnostics_active = not inline_diagnostics_active
    if inline_diagnostics_active then
        vim.diagnostic.config({
            -- virtual_text = inline_diagnostics_active
            virtual_lines = {
                only_current_line = inline_diagnostics_active
            }
        })
    else
        vim.diagnostic.config({
            -- virtual_text = inline_diagnostics_active
            virtual_lines = inline_diagnostics_active
        })
    end
end

local diagnostics_active = true
function _G.toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show(nil, 0)
    else
        vim.diagnostic.hide()
    end
end

vim.diagnostic.config({
    virtual_text = false, -- disable inline diagnostics by default
    virtual_lines = {
        only_current_line = true  -- show diagnostics only for current line
    }
})

-- change diagnostics icons --
local signs = {
    Error = " ",
    Warn = " ",
    Hint = "󰌵 ",
    Info = " "
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end


-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
