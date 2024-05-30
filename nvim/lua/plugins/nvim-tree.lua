local function get_root_folder(path)
    local last = ""
    for part in string.gmatch(path,"[^/]+") do
        if part ~= "/" then last = part end
    end
    return last
end
return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            renderer = {
                root_folder_label = get_root_folder,
            },
            view = {
                adaptive_size = true,
            }
        })
    end
}
