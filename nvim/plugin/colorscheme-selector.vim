augroup ColoschemeSelector
    autocmd!
augroup END

function! ColorschemeSelector()
   lua require('plenary.reload').module_reload('colorscheme-selector').helloWorld()
endfun

function! Kwa()
   lua require('telescope.builtin').git_files()
endfun
