vim.cmd.colorscheme("vscode")

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.cmd [[
      highlight IndentRainbow1 guifg=#E06C75 gui=nocombine
      highlight IndentRainbow2 guifg=#E5C07B gui=nocombine
      highlight IndentRainbow3 guifg=#98C379 gui=nocombine
      highlight IndentRainbow4 guifg=#56B6C2 gui=nocombine
      highlight IndentRainbow5 guifg=#61AFEF gui=nocombine
      highlight IndentRainbow6 guifg=#C678DD gui=nocombine
    ]]
    end,
})

vim.cmd [[
  highlight IndentRainbow1 guifg=#E06C75 gui=nocombine
  highlight IndentRainbow2 guifg=#E5C07B gui=nocombine
  highlight IndentRainbow3 guifg=#98C379 gui=nocombine
  highlight IndentRainbow4 guifg=#56B6C2 gui=nocombine
  highlight IndentRainbow5 guifg=#61AFEF gui=nocombine
  highlight IndentRainbow6 guifg=#C678DD gui=nocombine
]]
