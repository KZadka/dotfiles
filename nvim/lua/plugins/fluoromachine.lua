return {
    {
        'maxmx03/fluoromachine.nvim',
        config = function ()
         local fm = require 'fluoromachine'

         fm.setup {
            glow = false,
            theme = 'retrowave', -- (retrowave, delta, fluoromachine)
            brightness = 0.05,
            transparent = true,
            colors = {},
            overrides = {}
         }

         vim.cmd.colorscheme 'fluoromachine'
        end
    }
}
