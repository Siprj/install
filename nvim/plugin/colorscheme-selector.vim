augroup ColoschemeSelector
    autocmd!
augroup END

function! ColorschemeSelector()
   lua require('plenary.reload').reload_module('colorscheme-selector'); require('colorscheme-selector').helloWorld()
endfun

function! Kwa()
   lua require('telescope.builtin').git_files()
endfun
