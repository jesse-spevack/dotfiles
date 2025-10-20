
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true,  -- Show hidden files by default
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })
    vim.keymap.set('n', '<C-n>', ":Neotree filesystem toggle left reveal<CR>")
  end
}
