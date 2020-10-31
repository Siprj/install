""" A color scheme picker
let g:Color_scheme_picker_open     = 0
let g:Color_scheme_picker_selected = ''

fu! Color_scheme_picker()
    if g:Color_scheme_picker_open == 1
        echo 'Color_scheme_picker is alread open!'
        return
    endif

    let g:Color_scheme_picker_open     = 1
    let g:Color_scheme_picker_selected = g:colors_name

    let l:colors = getcompletion('', 'color')
    silent 12 new color_scheme_picker
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    put =l:colors
    norm ggdd
endfu

fu! Close_Color_scheme_picker()
    let g:Color_scheme_picker_open = 0
    execute 'color ' . g:Color_scheme_picker_selected
    redraw!
    echo 'Selected color scheme "' . g:Color_scheme_picker_selected . '".'
endfu

fu! Maybe_update_color()
    let l:current_color = g:colors_name
    let l:selected      = getline('.')

    if l:selected != l:current_color
        let l:changed = 0

        try
            execute 'color ' . l:selected
            let l:changed = 1
        catch /.*/
            execute 'color ' . g:Color_scheme_picker_selected
        finally
            redraw!
            if l:changed == 1
                echo 'Color scheme "' . l:selected . '"'
            else
                echom 'No such color scheme "' . l:selected . '" -- showing "' . g:Color_scheme_picker_selected . '"'
            endif
        endtry
    endif
endfu

fu! Select_Color_scheme()
    let g:Color_scheme_picker_selected = g:colors_name
    exe 'q'
endfu

au BufWipeout  color_scheme_picker call Close_Color_scheme_picker()
au CursorMoved color_scheme_picker call Maybe_update_color()
au BufEnter    color_scheme_picker nnoremap <buffer> <silent> <cr> :call Select_Color_scheme()<cr>
command! ColorSchemePicker call Color_scheme_picker()
