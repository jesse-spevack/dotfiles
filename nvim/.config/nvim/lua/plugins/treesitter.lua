
  return { 
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        highlight = { 
          auto_install = true,
          enable = truecolorscheme,
          additional_vim_regex_highlighting = false
        },
        indent = { enable = true },
      })
    end
  }
