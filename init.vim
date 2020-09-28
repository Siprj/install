
call plug#begin('~/.config/nvim/bundle')

Plug 'thaerkh/vim-indentguides'
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'easymotion/vim-easymotion'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'purescript-contrib/purescript-vim'
Plug 'FrigoEU/psc-ide-vim'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc-snippets'
Plug 'ryanoasis/vim-devicons'
" Plug 'jremmen/vim-ripgrep'

Plug 'dracula/vim'

call plug#end()

set termguicolors

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

let mapleader = ","
let g:mapleader = ","

" Leader key timeout
set tm=2000

" Allow the normal use of "," by pressing it twice
noremap ,, ,

" Use par for prettier line formatting
set formatprg=par
let $PARINIT = 'rTbgqR B=.,?_A_a Q=_s>|'

" Kill the damned Ex mode.
nnoremap Q <nop>

" Make <c-h> work like <c-h> again (this is a problem with libterm)
nnoremap <BS> <C-w>h

set noshowmode

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu
" Tab-complete files up to longest unambiguous prefix
set wildmode=list:longest,full

" Always show current position
set ruler
set number

" Show trailing whitespace
set list
" But only interesting whitespace
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Height of the command bar
set cmdheight=2

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set vb t_vb=

" Force redraw
map <silent> <leader>r :redraw!<CR>

" Turn mouse mode on
nnoremap <leader>ma :set mouse=a<cr>

" Turn mouse mode off
nnoremap <leader>mo :set mouse=<cr>

" Default to mouse mode off
set mouse=

try
  colorscheme dracula
catch
endtry

" Adjust signscolumn to match wombat
"hi! link SignColumn LineNr
"

"" Searing red very visible cursor
"hi Cursor guibg=red

" Don't blink normal mode cursor
set guicursor=n-v-c:block-Cursor
set guicursor+=n-v-c:blinkon0

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Use powerline fonts for airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#disable_rtp_load = 1
let g:airline_extensions = ['branch', 'hunks', 'coc']

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Turn backup off, since most stuff is in Git anyway...
set nobackup
set nowb
set noswapfile

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
    autocmd bufwritepost init.vim source $MYVIMRC
augroup END

" Fuzzy find files
nnoremap <silent> <Leader><space> :FZF<CR>

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
autocmd Filetype cpp,c setlocal tabstop=2 shiftwidth=2

" Linebreak on 500 characters
set lbr
set tw=500

"set ai "Auto indent
"set si "Smart indent
"set wrap "Wrap lines

" Copy and paste to os clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>d "+d
xnoremap <leader>d "+d
nnoremap <leader>p "+p
xnoremap <leader>p "+p

" Moving around, tabs, windows and buffers {{{

" Treat long lines as break lines (useful when moving around in them)
nnoremap j gj
nnoremap k gk

" Disable highlight when <leader><cr> is pressed
" but preserve cursor coloring
nmap <silent> <leader><cr> :noh\|hi Cursor guibg=red<cr>

" Return to last edit position when opening files (You want this!)
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END

" Remember info about open buffers on close
set viminfo^=%

" Open window splits in various places
nnoremap <leader>sh :leftabove  vnew<CR>
nnoremap <leader>sl :rightbelow vnew<CR>
nnoremap <leader>sk :leftabove  new<CR>
nnoremap <leader>sj :rightbelow new<CR>

" don't close buffers when you aren't displaying them
set hidden


let g:indentLine_char = '┆'

set colorcolumn=80

set guifont=DroidSansMono_Nerd_Font:h15

"" previous buffer, next buffer
"nnoremap <leader>bp :bp<cr>
"nnoremap <leader>bn :bn<cr>
"

" Neovim terminal configurations
" Use <Esc> to escape terminal insert mode
tnoremap <Esc> <C-\><C-n>

" Make terminal split moving behave like normal neovim
tnoremap <c-h> <C-\><C-n><C-w>h
tnoremap <c-j> <C-\><C-n><C-w>j
tnoremap <c-k> <C-\><C-n><C-w>k
tnoremap <c-l> <C-\><C-n><C-w>l

" Always show the status line
set laststatus=2

" Utility function to delete trailing white space
func! DeleteTrailingWS()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunc

autocmd FileType c,cpp,java,haskell,javascript,python autocmd BufWritePre <buffer> :call DeleteTrailingWS()

nnoremap <F6> :UndotreeToggle<cr>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

nmap f <Plug>(easymotion-f)
nmap F <Plug>(easymotion-F)
nmap <silent> <leader>w <Plug>(easymotion-w)
nmap <silent> <leader>W <Plug>(easymotion-W)
nmap <silent> <leader>e <Plug>(easymotion-e)
nmap <silent> <leader>E <Plug>(easymotion-E)
nmap <silent> <leader>j <Plug>(easymotion-j)
nmap <silent> <leader>k <Plug>(easymotion-l)
xmap f <Plug>(easymotion-f)
xmap F <Plug>(easymotion-F)
xmap <silent> <leader>w <Plug>(easymotion-w)
xmap <silent> <leader>W <Plug>(easymotion-W)
xmap <silent> <leader>e <Plug>(easymotion-e)
xmap <silent> <leader>E <Plug>(easymotion-E)
xmap <silent> <leader>j <Plug>(easymotion-j)
xmap <silent> <leader>k <Plug>(easymotion-l)
omap f <Plug>(easymotion-f)
omap F <Plug>(easymotion-F)
omap <silent> <leader>w <Plug>(easymotion-w)
omap <silent> <leader>W <Plug>(easymotion-W)
omap <silent> <leader>e <Plug>(easymotion-e)
omap <silent> <leader>E <Plug>(easymotion-E)
omap <silent> <leader>j <Plug>(easymotion-j)
omap <silent> <leader>k <Plug>(easymotion-l)

" Close nerdtree after a file is selected
let NERDTreeQuitOnOpen = 1

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! ToggleFindNerd()
  if IsNERDTreeOpen()
    exec ':NERDTreeToggle'
  else
   exec ':NERDTreeFind'
  endif
endfunction

" If nerd tree is closed, find current file, if open, close it/
nmap <silent> <leader>o <ESC>:call ToggleFindNerd()<CR>

"" Without this there are some '+' or '.' before file names.
"autocmd FileType nerdtree setlocal nolist

let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

let g:NERDTreeHighlightFolders = 1 " Enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " Highlights the folder name

" Change NERDTree icon appearance
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" Tags {{{

map <leader>tt :TagbarToggle<CR>

set tags=tags;/
set cst
set csverb

" Tagbar setup
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'fast-tags',
    \ 'ctagsargs' : '-o -',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'f:function types:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

let g:extradite_width = 60
" Hide messy Ggrep output and copen automatically
function! NonintrusiveGitGrep(term)
  execute "copen"
  " Map 't' to open selected item in new tab
  execute "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
  execute "silent! Ggrep " . a:term
  execute "redraw!"
endfunction

command! -nargs=1 GGrep call NonintrusiveGitGrep(<q-args>)
nmap <leader>gs :Gstatus<CR>
nmap <leader>gg :copen<CR>:GGrep 
nmap <leader>gl :Extradite!<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gb :Gblame<CR>

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)<Paste>

" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)

" Remap for do action format
nnoremap <silent> <leader>cf :call CocAction('format')<CR>

" Show signature help
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Show all diagnostics
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

" Close preview (shown for hover / signature help)
nnoremap <leader> <Esc> :pclose<CR>

call coc#config('languageserver', {
    \ "clangd": {
    \   "command": "clangd",
    \   "rootPatterns": ["compile_commands.json"],
    \   "filetypes": ["c", "cpp", "h", "hpp"]
    \ },
    \ "haskell-ide": {
    \   "command": "haskell-language-server-wrapper",
    \   "args": ["--lsp"],
    \   "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
    \   "filetypes": ["haskell", "lhaskell"]
    \ }
    \})

"set completeopt=noinsert,menuone,noselect
"" use <tab> for trigger completion and navigate to next complete item
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~ '\s'
"endfunction
"
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
"
"
"
"function! s:show_documentation()
"  if &filetype == 'vim'
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction
"
"nnoremap <F5> :CocList<CR>
"" Or map each action separately
"nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>
"nmap <silent> <F2> <Plug>(coc-rename)
"
"nmap <silent> <leader>gd <Plug>(coc-definition)
"nmap <silent> <leader>gy <Plug>(coc-type-definition)
"nmap <silent> <leader>gi <Plug>(coc-implementation)
"nmap <silent> <leader>gr <Plug>(coc-references)
"
"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"nmap <silent> <leader>< <Plug>(coc-diagnostic-prev)
"nmap <silent> <leader>> <Plug>(coc-diagnostic-next)
"nmap <silent> <leader>c <Plug>(coc-fix-current)
"
"
"" }}} coc

let g:psc_ide_log_level = 3
