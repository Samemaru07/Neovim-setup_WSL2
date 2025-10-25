vim.cmd.colorscheme("vscode")

local function apply_transparency()
    vim.cmd([[
      highlight Normal guibg=NONE
      highlight NormalNC guibg=NONE
      highlight NonText guibg=NONE
      highlight EndOfBuffer guibg=NONE
      highlight SignColumn guibg=NONE
      highlight NvimTreeNormal guibg=NONE
      highlight NvimTreeVertSplit guibg=NONE
      highlight NvimTreeEndOfBuffer guibg=NONE
      highlight NvimTreeStatusLine guibg=NONE
      highlight NvimTreeStatusLineNC guibg=NONE
    ]])
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.cmd([[
          highlight IndentRainbow1 guifg=#E06C75 gui=nocombine
          highlight IndentRainbow2 guifg=#E5C07B gui=nocombine
          highlight IndentRainbow3 guifg=#98C379 gui=nocombine
          highlight IndentRainbow4 guifg=#56B6C2 gui=nocombine
          highlight IndentRainbow5 guifg=#61AFEF gui=nocombine
          highlight IndentRainbow6 guifg=#C678DD gui=nocombine
        ]])
        apply_transparency()
    end,
})

apply_transparency()
