" `<leader>ss` command
" TODO: look at:
" :earlier {count}	Go to older text state {count} times.
" :earlier {N}s		Go to older text state about {N} seconds before.
" :earlier {N}m		Go to older text state about {N} minutes before.
" :earlier {N}h		Go to older text state about {N} hours before.
" :earlier {N}d		Go to older text state about {N} days before.
" :earlier {N}f		Go to older text state {N} file writes before.
" 			When changes were made since the last write
" 			":earlier 1f" will revert the text to the state when
" 			it was written.  Otherwise it will go to the write
" 			before that.
" 			When at the state of the first file write, or when
" 			the file was not written, ":earlier 1f" will go to
" 			before the first change.
" 
" 							*g+*
" g+			Go to newer text state.  With a count repeat that many
" 			times.
" 							*:lat* *:later*
" :later {count}		Go to newer text state {count} times.
" :later {N}s		Go to newer text state about {N} seconds later.
" :later {N}m		Go to newer text state about {N} minutes later.
" :later {N}h		Go to newer text state about {N} hours later.
" :later {N}d		Go to newer text state about {N} days later.
" 
" :later {N}f		Go to newer text state {N} file writes later.


" Polyglot should only do syntax parsing and filetype detection.
" This has to be set before polyglot plugin is loaded.
let g:polyglot_disabled = ['sensible', 'autoindent']

call plug#begin('~/.config/nvim/bundle')

" Color highlighter.
Plug 'norcalli/nvim-colorizer.lua'

" Allows to write colorschemes in lua.
Plug 'tjdevries/colorbuddy.vim'

" Better syntax highlighting for grate number of filetypes.
Plug 'sheerun/vim-polyglot'

" My old colorscheme if I ever want to come back.
Plug 'dracula/vim', { 'as': 'dracula' }

" My new colorscheme.
Plug 'ghifarit53/tokyonight-vim'

" Telescope and it dependences.
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

" Cool start screen, so I don't need to pick random files to use fuzzy finders.
Plug 'mhinz/vim-startify'

" NerdTree  is nice but I think it is time to try new file explorer :)
Plug 'kyazdani42/nvim-web-devicons'
Plug 'Siprj/nvim-tree.lua'

" Nice cheatsheet with key bindings.
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

Plug 'mbbill/undotree'

" Really nice and fluid way to move around the file without the need for 
" complicated commands.
Plug 'easymotion/vim-easymotion'

" I use only git blame form this. TODO: Maybe I can get rid of it?
Plug 'tpope/vim-fugitive'

" Lazygit integration for neovim. Uses lua :).
Plug 'kdheepak/lazygit.nvim'

" Fuzzy file exploration.
" Fzf has much better fuzzy finder than telescope for now.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" lsp hurray
Plug 'neovim/nvim-lspconfig'

" Nice diagnostics from lsp
Plug 'nvim-lua/diagnostic-nvim'

" Completions fupport for lsp
Plug 'nvim-lua/completion-nvim'

" Nice code actions???
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'

call plug#end()

""" General setup
" Allow more colors.
set termguicolors

let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
" let g:tokyonight_transparent_background = 1

try
  colorscheme tokyonight
catch
endtry

" Sets how many lines of history VIM has to remember.
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" Comma is really easy to type :)
let mapleader = ","
let g:mapleader = ","

" Allow the normal use of "," by pressing it twice.
noremap ,, ,

" Wait a bit longer for mapped sequence to complete. It can be rather long and
" sometimes I need more time figure out what I'm suppose to type.
set tm=1000

" Turn backup off, since most stuff is in Git anyway...
set nobackup
set nowb
set noswapfile

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
    autocmd bufwritepost init.vim source $MYVIMRC
    autocmd bufwritepost new_configuration.vim source $MYVIMRC
    autocmd bufwritepost old_configuration.vim source $MYVIMRC
augroup END

" Use par for prettier line formatting.
set formatprg=par
let $PARINIT = 'rTbgqR B=.,?_A_a Q=_s>|'

" Kill the damned Ex mode.
nnoremap Q <nop>

" Don't put mode name (Insert, Replace or Visual) into the comand line. This
" information is supose to be in the status line anywway.
set noshowmode

" Additional 7 lines above and below cursor when scrolling. This allow me to
" see more cleary what I'm about to edit.
set so=7

" Show line numbers.
set ruler
set number

" Turn on the WiLd menu.
set wildmenu
" Tab-complete files up to longest unambiguous prefix.
set wildmode=list:longest,full

" Show trailing whitespace.
set list
" But only interesting whitespace.
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Configure backspace so it acts as it should act.
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching.
set ignorecase

" TODO: Do I really want this? Maybe it would be better to create function
" which will turn case sensitivity searches and then turns it back on.
set smartcase

" Don't redraw while executing macros (good performance config).
set lazyredraw

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them.
set showmatch

" How many tenths of a second to blink when matching brackets.
set mat=2

" Use spaces instead of tabs.
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters.
set lbr
set tw=500

" Default to mouse mode off.
set mouse=

" Show nice line at 80 character mark.
set colorcolumn=80

" Use nice font in GUI version if ever happen to open it.
set guifont=DroidSansMono_Nerd_Font:h15

" Don't close buffers when you aren't displaying them.
" TODO: This was a cause of some pain it the past. Find a way to list unsaved buffers?
set hidden

" Copy and paste to os clipboard.
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>d "+d
xnoremap <leader>d "+d
nnoremap <leader>p "+p
xnoremap <leader>p "+p

" Treat long lines as break lines (useful when moving around in them)
nnoremap j gj
nnoremap k gk

" Force redraw.
map <silent> <leader>r :redraw!<CR>

" Turn mouse mode on.
nnoremap <leader>ma :set mouse=a<CR>

" Turn mouse mode off.
nnoremap <leader>mo :set mouse=<CR>

" Neovim terminal configurations
" Use <Esc> to escape terminal insert mode
tnoremap <Esc> <C-\><C-n>

" Make terminal split moving behave like normal neovim
tnoremap <c-h> <C-\><C-n><C-w>h
tnoremap <c-j> <C-\><C-n><C-w>j
tnoremap <c-k> <C-\><C-n><C-w>k
tnoremap <c-l> <C-\><C-n><C-w>l

" Really usefull feature.
" TODO: I don't think I'm using this wary often. Maybe this remap is not needed?
nnoremap <F6> :UndotreeToggle<CR>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<CR>

" Remember info about open buffers on close so we can open them later on the
" same position.
set shada^=%

" Return to last edit position when opening files.
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END

" Utility function to delete trailing white space.
func! DeleteTrailingWS()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunc

autocmd FileType c,cpp,java,haskell,javascript,python autocmd BufWritePre <buffer> :call DeleteTrailingWS()


""" Configure startify
"
" Returns all modified files of the current git repo.
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty.
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" Startifi configuration
let g:startify_change_to_vcs_root = 1
let g:startify_files_number        = 7
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1
let g:startify_fortune_use_unicode = 1
let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]


""" nvim-tree (lua-tree) configuration
let g:lua_tree_side = 'left' "left by default
let g:lua_tree_width = 30 "30 by default
let g:lua_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:lua_tree_auto_open = 0 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:lua_tree_auto_close = 0 "0 by default, closes the tree when it's the last window
let g:lua_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:lua_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:lua_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:lua_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:lua_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:lua_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:lua_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:lua_tree_allow_resize = 0 "0 by default, will not resize the tree when opening a file
" TODO: Git feature may be anoying in future.
let g:lua_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ }

" You can edit keybindings be defining this variable
" You don't have to define all keys.
" NOTE: the 'edit' key will wrap/unwrap a folder and open a file
let g:lua_tree_bindings = {
    \ 'edit':            ['<CR>', 'o'],
    \ 'edit_vsplit':     'i',
    \ 'edit_split':      '<C-x>',
    \ 'edit_tab':        't',
    \ 'toggle_ignored':  'I',
    \ 'toggle_dotfiles': 'H',
    \ 'refresh':         'R',
    \ 'preview':         '<Tab>',
    \ 'cd':              '<C-]>',
    \ 'create':          'a',
    \ 'remove':          'd',
    \ 'rename':          'r',
    \ 'cut':             'x',
    \ 'copy':            'c',
    \ 'paste':           'p',
    \ 'prev_git_item':   '[c',
    \ 'next_git_item':   ']c',
    \ }

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:lua_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': ""
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': ""
    \   }
    \ }

" TODO: Play with lua-tree colors.
nmap <silent> <leader>o <ESC>:LuaTreeToggle<CR>


""" Configure which key
"
" TODO: Create leader key_map.
function! WhichKeyLeader()
    WhichKey(g:mapleader)
endfunction

" autocmd! User vim-which-key call which_key#register(',', 'g:leader_which_key_map')
autocmd! User vim-which-key call which_key#register('', 'g:which_key_map')
nmap <silent> <Space> :<C-u>WhichKey ''<CR>
nmap <silent> <leader> :call WhichKeyLeader()<CR>

let g:leader_which_key_map = {
      \ 'name' : '+leader ',
      \ 'o' : [mapleader . 'o', 'open file explorer'],
      \ 'm' : {
      \   'name' : '+mouse',
      \   'a': [mapleader . 'ma', 'mouse on'],
      \   'o': [mapleader . 'mo', 'mouse off'],
      \   },
      \ }
let g:which_key_map = {}
let g:which_key_map['w'] = {
      \ 'name' : '+windows <C-w>',
      \ 'w' : ['<C-W>w', 'other-window'],
      \ 'c' : ['<C-W>c', 'delete-window'],
      \ 's' : ['<C-W>s', 'split-window-below'],
      \ 'v' : ['<C-W>v', 'split-window-right'],
      \ 'h' : ['<C-W>h', 'window-left'],
      \ 'j' : ['<C-W>j', 'window-below'],
      \ 'l' : ['<C-W>l', 'window-right'],
      \ 'k' : ['<C-W>k', 'window-up'],
      \ '=' : ['<C-W>=', 'balance-window'],
      \ }
let g:which_key_map[','] = g:leader_which_key_map


" Configure easymotion
" TODO: Look at it again there are some interesting examples in README.
" Combination with `incsearch.vim` and `incsearch-fuzzy.vim` looks really nice.
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


" Configure vim-fugitive
" Hide messy Ggrep output and copen automatically
function! NonintrusiveGitGrep(term)
  execute "copen"
  " Map 't' to open selected item in new tab
  execute "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
  execute "silent! Ggrep " . a:term
  execute "redraw!"
endfunction

command! -nargs=1 GGrep call NonintrusiveGitGrep(<q-args>)
nnoremap <leader>gg :GGrep 
nnoremap <silent> <leader>gb :Gblame<CR>


" Configure LazyGit
" TODO: Look at some advanced configuration with remote nvim.
nnoremap <silent> <leader>lg :LazyGit<CR>


" Configure fzf
nnoremap <silent> <leader><space> :Files<CR>


" Configure telescope
nnoremap <silent> <leader>t :lua require'telescope.builtin'.builtin()<CR>
nnoremap <silent> <leader>tl :lua require'telescope.builtin'.live_grep()<CR>
nnoremap <silent> <leader>tg :lua require'telescope.builtin'.git_files()<CR>


" Configure lsp
lua <<EOF
local on_attach = function(client)
  require'diagnostic'.on_attach(client)
  require'completion'.on_attach(client)
end
require'nvim_lsp'.hls.setup{on_attach=on_attach}
vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler

vim.g.lsp_utils_codeaction_opts = { list = { border = false, numbering = false } }
EOF

nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>

nnoremap <silent> <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader><c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>lD <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>lr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>l1 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>lw <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>ld <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>la <cmd>lua vim.lsp.buf.code_action()<CR>

call sign_define("LspDiagnosticsErrorSign", {"text" : "✗", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})

highlight LspDiagnosticsError gui=bold guifg=#F7768E
highlight LspDiagnosticsWarning gui=bold guifg=#E0AF68
highlight link LspDiagnosticsInformation TermCursorNC
highlight LspDiagnosticsHint gui=bold guifg=#FFCC33

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '

nnoremap <silent> [c :PrevDiagnosticCycle<CR>
nnoremap <silent> ]c :NextDiagnosticCycle<CR>

" set completeopt=noinsert,menuone,noselect
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <silent> <c-p> <Plug>(completion_trigger)

let g:completion_auto_change_source = 1
imap <c-j> <Plug>(completion_next_source)
imap <c-k> <Plug>(completion_prev_source)

let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

let g:completion_matching_strategy_list = ["fuzzy", "exact", "substring", "all"]
let g:completion_matching_ignore_case = 1
" TODO: This may be a really bad idea
let g:completion_matching_smart_case = 1

" TODO: Snippets

"call plug#begin('~/.config/nvim/bundle')
"
"Plug 'thaerkh/vim-indentguides'
"Plug 'tpope/vim-fugitive'
"Plug 'int3/vim-extradite'
"Plug 'scrooloose/nerdtree'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug 'vim-airline/vim-airline'
"Plug 'majutsushi/tagbar'
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'
"Plug 'mbbill/undotree'
"Plug 'easymotion/vim-easymotion'
"Plug 'ConradIrwin/vim-bracketed-paste'
"Plug 'vim-scripts/DoxygenToolkit.vim'
"Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
"Plug 'purescript-contrib/purescript-vim'
"Plug 'FrigoEU/psc-ide-vim'
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
"Plug 'neoclide/coc-snippets'
"Plug 'ryanoasis/vim-devicons'
"" Plug 'jremmen/vim-ripgrep'
"
"Plug 'dracula/vim'
"
"call plug#end()
"
"" Leader key timeout
"set tm=2000
"
"" Use par for prettier line formatting
"set formatprg=par
"let $PARINIT = 'rTbgqR B=.,?_A_a Q=_s>|'
"
"" Kill the damned Ex mode.
"nnoremap Q <nop>
"
"" Make <c-h> work like <c-h> again (this is a problem with libterm)
"nnoremap <BS> <C-w>h
"
"set noshowmode
"
"" Set 7 lines to the cursor - when moving vertically using j/k
"set so=7
"
"" Turn on the WiLd menu
"set wildmenu
"" Tab-complete files up to longest unambiguous prefix
"set wildmode=list:longest,full
"
"" Always show current position
"set ruler
"set number
"
"" Show trailing whitespace
"set list
"" But only interesting whitespace
"if &listchars ==# 'eol:$'
"  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
"endif
"
"" Height of the command bar
"set cmdheight=2
"
"" Configure backspace so it acts as it should act
"set backspace=eol,start,indent
"set whichwrap+=<,>,h,l
"
"" Ignore case when searching
"set ignorecase
"
"" When searching try to be smart about cases
"set smartcase
"
"" Highlight search results
"set hlsearch
"
"" Makes search act like search in modern browsers
"set incsearch
"
"" Don't redraw while executing macros (good performance config)
"set lazyredraw
"
"" For regular expressions turn magic on
"set magic
"
"" Show matching brackets when text indicator is over them
"set showmatch
"" How many tenths of a second to blink when matching brackets
"set mat=2
"
"" No annoying sound on errors
"set noerrorbells
"set vb t_vb=
"
"" Force redraw
"map <silent> <leader>r :redraw!<CR>
"
"" Turn mouse mode on
"nnoremap <leader>ma :set mouse=a<cr>
"
"" Turn mouse mode off
"nnoremap <leader>mo :set mouse=<cr>
"
"" Default to mouse mode off
"set mouse=
"
"try
"  colorscheme dracula
"catch
"endtry
"
"" Adjust signscolumn to match wombat
""hi! link SignColumn LineNr
""
"
""" Searing red very visible cursor
""hi Cursor guibg=red
"
"" Don't blink normal mode cursor
"set guicursor=n-v-c:block-Cursor
"set guicursor+=n-v-c:blinkon0
"
"" Use Unix as the standard file type
"set ffs=unix,dos,mac
"
"" Use powerline fonts for airline
"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"
"let g:airline_powerline_fonts = 1
"let g:airline_symbols.space = "\ua0"
"let g:airline#extensions#disable_rtp_load = 1
"let g:airline_extensions = ['branch', 'hunks', 'coc']
"
"let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
"let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
"
"" Turn backup off, since most stuff is in Git anyway...
"set nobackup
"set nowb
"set noswapfile
"
"" Source the vimrc file after saving it
"augroup sourcing
"  autocmd!
"    autocmd bufwritepost init.vim source $MYVIMRC
"augroup END
"
"" Fuzzy find files
"nnoremap <silent> <Leader><space> :FZF<CR>
"
"" Use spaces instead of tabs
"set expandtab
"
"" Be smart when using tabs ;)
"set smarttab
"
"" 1 tab == 4 spaces
"set shiftwidth=4
"set tabstop=4
"autocmd Filetype cpp,c setlocal tabstop=2 shiftwidth=2
"
"" Linebreak on 500 characters
"set lbr
"set tw=500
"
""set ai "Auto indent
""set si "Smart indent
""set wrap "Wrap lines
"
"" Copy and paste to os clipboard
"nnoremap <leader>y "+y
"xnoremap <leader>y "+y
"nnoremap <leader>d "+d
"xnoremap <leader>d "+d
"nnoremap <leader>p "+p
"xnoremap <leader>p "+p
"
"" Moving around, tabs, windows and buffers {{{
"
"" Treat long lines as break lines (useful when moving around in them)
"nnoremap j gj
"nnoremap k gk
"
"" Disable highlight when <leader><cr> is pressed
"" but preserve cursor coloring
"nmap <silent> <leader><cr> :noh\|hi Cursor guibg=red<cr>
"
"" Return to last edit position when opening files (You want this!)
"augroup last_edit
"  autocmd!
"  autocmd BufReadPost *
"       \ if line("'\"") > 0 && line("'\"") <= line("$") |
"       \   exe "normal! g`\"" |
"       \ endif
"augroup END
"
"" Remember info about open buffers on close
"set viminfo^=%
"
"" Open window splits in various places
"nnoremap <leader>sh :leftabove  vnew<CR>
"nnoremap <leader>sl :rightbelow vnew<CR>
"nnoremap <leader>sk :leftabove  new<CR>
"nnoremap <leader>sj :rightbelow new<CR>
"
"" don't close buffers when you aren't displaying them
"set hidden
"
"
"let g:indentLine_char = '┆'
"
"set colorcolumn=80
"
"set guifont=DroidSansMono_Nerd_Font:h15
"
""" previous buffer, next buffer
""nnoremap <leader>bp :bp<cr>
""nnoremap <leader>bn :bn<cr>
""
"
"" Neovim terminal configurations
"" Use <Esc> to escape terminal insert mode
"tnoremap <Esc> <C-\><C-n>
"
"" Make terminal split moving behave like normal neovim
"tnoremap <c-h> <C-\><C-n><C-w>h
"tnoremap <c-j> <C-\><C-n><C-w>j
"tnoremap <c-k> <C-\><C-n><C-w>k
"tnoremap <c-l> <C-\><C-n><C-w>l
"
"" Always show the status line
"set laststatus=2
"
"" Utility function to delete trailing white space
"func! DeleteTrailingWS()
"    let l:save = winsaveview()
"    %s/\s\+$//e
"    call winrestview(l:save)
"endfunc
"
"autocmd FileType c,cpp,java,haskell,javascript,python autocmd BufWritePre <buffer> :call DeleteTrailingWS()
"
"nnoremap <F6> :UndotreeToggle<cr>
"
"" Pressing ,ss will toggle and untoggle spell checking
"map <leader>ss :setlocal spell!<cr>
"
"nmap f <Plug>(easymotion-f)
"nmap F <Plug>(easymotion-F)
"nmap <silent> <leader>w <Plug>(easymotion-w)
"nmap <silent> <leader>W <Plug>(easymotion-W)
"nmap <silent> <leader>e <Plug>(easymotion-e)
"nmap <silent> <leader>E <Plug>(easymotion-E)
"nmap <silent> <leader>j <Plug>(easymotion-j)
"nmap <silent> <leader>k <Plug>(easymotion-l)
"xmap f <Plug>(easymotion-f)
"xmap F <Plug>(easymotion-F)
"xmap <silent> <leader>w <Plug>(easymotion-w)
"xmap <silent> <leader>W <Plug>(easymotion-W)
"xmap <silent> <leader>e <Plug>(easymotion-e)
"xmap <silent> <leader>E <Plug>(easymotion-E)
"xmap <silent> <leader>j <Plug>(easymotion-j)
"xmap <silent> <leader>k <Plug>(easymotion-l)
"omap f <Plug>(easymotion-f)
"omap F <Plug>(easymotion-F)
"omap <silent> <leader>w <Plug>(easymotion-w)
"omap <silent> <leader>W <Plug>(easymotion-W)
"omap <silent> <leader>e <Plug>(easymotion-e)
"omap <silent> <leader>E <Plug>(easymotion-E)
"omap <silent> <leader>j <Plug>(easymotion-j)
"omap <silent> <leader>k <Plug>(easymotion-l)
"
"" Close nerdtree after a file is selected
"let NERDTreeQuitOnOpen = 1
"
"function! IsNERDTreeOpen()
"  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
"endfunction
"
"function! ToggleFindNerd()
"  if IsNERDTreeOpen()
"    exec ':NERDTreeToggle'
"  else
"   exec ':NERDTreeFind'
"  endif
"endfunction
"
"" If nerd tree is closed, find current file, if open, close it/
"nmap <silent> <leader>o <ESC>:call ToggleFindNerd()<CR>
"
""" Without this there are some '+' or '.' before file names.
""autocmd FileType nerdtree setlocal nolist
"
"let g:NERDTreeFileExtensionHighlightFullName = 1
"let g:NERDTreeExactMatchHighlightFullName = 1
"let g:NERDTreePatternMatchHighlightFullName = 1
"
"let g:NERDTreeHighlightFolders = 1 " Enables folder icon highlighting using exact match
"let g:NERDTreeHighlightFoldersFullName = 1 " Highlights the folder name
"
"" Change NERDTree icon appearance
"let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"
"" Tags {{{
"
"map <leader>tt :TagbarToggle<CR>
"
"set tags=tags;/
"set cst
"set csverb
"
"" Tagbar setup
"let g:tagbar_type_haskell = {
"    \ 'ctagsbin'  : 'fast-tags',
"    \ 'ctagsargs' : '-o -',
"    \ 'kinds'     : [
"        \  'm:modules:0:1',
"        \  'd:data: 0:1',
"        \  'd_gadt: data gadt:0:1',
"        \  't:type names:0:1',
"        \  'nt:new types:0:1',
"        \  'c:classes:0:1',
"        \  'cons:constructors:1:1',
"        \  'c_gadt:constructor gadt:1:1',
"        \  'c_a:constructor accessors:1:1',
"        \  'f:function types:0:1',
"        \  'o:others:0:1'
"    \ ],
"    \ 'sro'        : '.',
"    \ 'kind2scope' : {
"        \ 'm' : 'module',
"        \ 'c' : 'class',
"        \ 'd' : 'data',
"        \ 't' : 'type'
"    \ },
"    \ 'scope2kind' : {
"        \ 'module' : 'm',
"        \ 'class'  : 'c',
"        \ 'data'   : 'd',
"        \ 'type'   : 't'
"    \ }
"\ }
"
"let g:extradite_width = 60
"" Hide messy Ggrep output and copen automatically
"function! NonintrusiveGitGrep(term)
"  execute "copen"
"  " Map 't' to open selected item in new tab
"  execute "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
"  execute "silent! Ggrep " . a:term
"  execute "redraw!"
"endfunction
"
"command! -nargs=1 GGrep call NonintrusiveGitGrep(<q-args>)
"nmap <leader>gs :Gstatus<CR>
"nmap <leader>gg :copen<CR>:GGrep 
"nmap <leader>gl :Extradite!<CR>
"nmap <leader>gd :Gdiff<CR>
"nmap <leader>gb :Gblame<CR>
"
"" Use <c-space> for trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"
"" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"
"" Use `[c` and `]c` for navigate diagnostics
"nmap <silent> [c <Plug>(coc-diagnostic-prev)
"nmap <silent> ]c <Plug>(coc-diagnostic-next)
"
"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)<Paste>
"
"" Remap for do codeAction of current line
"nmap <leader>ac <Plug>(coc-codeaction)
"
"" Remap for do action format
"nnoremap <silent> <leader>cf :call CocAction('format')<CR>
"
"" Show signature help
"autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"
"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Use K for show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"  if &filetype == 'vim'
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction
"
"" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)
"
"" Show all diagnostics
"nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
"" Find symbol of current document
"nnoremap <silent> <space>o :<C-u>CocList outline<cr>
"" Search workspace symbols
"nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent> <space>j :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> <space>k :<C-u>CocPrev<CR>
"" Resume latest coc list
"nnoremap <silent> <space>p :<C-u>CocListResume<CR>
"
"" Close preview (shown for hover / signature help)
"nnoremap <leader> <Esc> :pclose<CR>
"
"
"call coc#config('languageserver', {
"    \ "clangd": {
"    \   "command": "clangd",
"    \   "rootPatterns": ["compile_commands.json"],
"    \   "filetypes": ["c", "cpp", "h", "hpp"]
"    \ },
"    \ "haskell-ide": {
"    \   "command": "haskell-language-server-wrapper",
"    \   "args": ["--lsp"],
"    \   "rootPatterns": [
"    \     "*.cabal",
"    \     "stack.yaml",
"    \     "cabal.project",
"    \     "package.yaml"
"    \   ],
"    \   "filetypes": [
"    \     "hs",
"    \     "lhs",
"    \     "haskell"
"    \   ],
"    \   "initializationOptions": {
"    \     "languageServerHaskell": {
"    \     }
"    \   }
"    \ }
"    \})
"
""set completeopt=noinsert,menuone,noselect
""" use <tab> for trigger completion and navigate to next complete item
""function! s:check_back_space() abort
""  let col = col('.') - 1
""  return !col || getline('.')[col - 1]  =~ '\s'
""endfunction
""
""inoremap <silent><expr> <TAB>
""      \ pumvisible() ? "\<C-n>" :
""      \ <SID>check_back_space() ? "\<TAB>" :
""      \ coc#refresh()
""
""inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
""inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
""inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
""autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
""
""
""
""function! s:show_documentation()
""  if &filetype == 'vim'
""    execute 'h '.expand('<cword>')
""  else
""    call CocAction('doHover')
""  endif
""endfunction
""
""nnoremap <F5> :CocList<CR>
""" Or map each action separately
""nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>
""nmap <silent> <F2> <Plug>(coc-rename)
""
""nmap <silent> <leader>gd <Plug>(coc-definition)
""nmap <silent> <leader>gy <Plug>(coc-type-definition)
""nmap <silent> <leader>gi <Plug>(coc-implementation)
""nmap <silent> <leader>gr <Plug>(coc-references)
""
""" Highlight symbol under cursor on CursorHold
""autocmd CursorHold * silent call CocActionAsync('highlight')
""
""nmap <silent> <leader>< <Plug>(coc-diagnostic-prev)
""nmap <silent> <leader>> <Plug>(coc-diagnostic-next)
""nmap <silent> <leader>c <Plug>(coc-fix-current)
""
""
""" }}} coc
