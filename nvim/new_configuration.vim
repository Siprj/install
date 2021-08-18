set runtimepath+=/home/yrid//.local/share/nvim/runtime

" Polyglot should only do syntax parsing and filetype detection.
" This has to be set before polyglot plugin is loaded.
let g:polyglot_disabled = ['sensible', 'autoindent']

" TODO: Look at following stuff:
"  * https://github.com/zatchheems/vim-camelsnek
"  * https://github.com/zatchheems/tokyo-night-alacritty-theme
"  * https://vim.rtorr.com/
"  * https://github.com/nvim-lua/lsp_extensions.nvim
"  * https://github.com/norcalli/snippets.nvim

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

" nerdtree is still more stable then nvim-tree
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

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

" Completions fupport for lsp
Plug 'nvim-lua/completion-nvim'

Plug 'glepnir/lspsaga.nvim'

Plug 'nvim-lua/lsp-status.nvim'
Plug 'hoob3rt/lualine.nvim'

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

set foldlevel=1

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

autocmd FileType c,cpp,java,haskell,javascript,python,elm autocmd BufWritePre <buffer> :call DeleteTrailingWS()

let g:haskell_indent_disable = 1


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
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local on_attach = function(client)
  require'completion'.on_attach(client)
  lsp_status.on_attach(client)
end
require'lspconfig'.hls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities, cmd = {"run-hls.sh", "--lsp"}}
require'lspconfig'.rust_analyzer.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
require'lspconfig'.elmls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
local saga = require 'lspsaga'
saga.init_lsp_saga{
--  use_saga_diagnostic_sign = true
--  dianostic_header_icon = '   ',
--  code_action_icon = ' ',
--  code_action_keys = { quit = 'q',exec = '<CR>' }
--  finder_definition_icon = '  ',
--  finder_reference_icon = '  ',
--  max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
--  finder_action_keys = {
--    open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
--  },
--  code_action_keys = {
--    quit = 'q',exec = '<CR>'
--  },
--  rename_action_keys = {
--    quit = '<C-c>',exec = '<CR>'  -- quit can be a table
--  },
--  definition_preview_icon = '  '
--  1: thin border | 2: rounded border | 3: thick border | 4: ascii border
--  border_style = 1,
--  rename_prompt_prefix = '➤',
--  if you don't use nvim-lspconfig you must pass your server name and
--  the related filetypes into this table
  border_style = 2,
  error_sign = '✗',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
}

EOF


nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>

nnoremap <silent> <leader>lh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent> <leader>lpd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent> <leader>ls <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
vnoremap <silent> <leader>la <cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>
nnoremap <silent> <leader>la <cmd>lua require('lspsaga.codeaction').code_action()<CR>
nnoremap <silent> <leader>lr <cmd>lua require('lspsaga.rename').rename()<CR>

nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

nnoremap <silent> [c <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]c <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>


nnoremap <silent> <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>lD <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>l1 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>lw <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>ld <cmd>lua vim.lsp.buf.declaration()<CR>

" Configure completion-nvim
" set completeopt=noinsert,menuone,noselect
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)
imap <silent> <c-p> <Plug>(completion_trigger)
imap <silent> <c-n> <Plug>(completion_trigger)

" I don't want to get a seizure :D
" It is really annoying when stuff trigger on it's own. Maybe it could be fine
" if it ware relevant?
let g:completion_enable_auto_popup = 0
let g:completion_auto_change_source = 1
imap <c-j> <Plug>(completion_next_source)
imap <c-k> <Plug>(completion_prev_source)

let g:completion_chain_complete_list = [
    \{'complete_items': ['<c-n>', 'lsp', 'snippet']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

let g:completion_matching_strategy_list = ["exact", "substring", "fuzzy", "all"]
let g:completion_matching_ignore_case = 1
" TODO: This may be a really bad idea
let g:completion_matching_smart_case = 1

" TODO: Snippets


" lualine
lua <<EOF
    local lualine = require('lualine')

    function getStatusFunc () return require('lsp-status').status() end
    local config = { 
      options = {
        theme = 'nightfly',
        section_separators = {'', ''},
        component_separators = {'', ''},
        icons_enabled = true
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { getStatusFunc, 'progress' },
        lualine_z = { 'location'  }
      },
      inactive_sections = {
        lualine_a = {  },
        lualine_b = {  },
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {  },
        lualine_z = {   }
      },
      extensions = { 'fzf' }
    }
    lualine.setup(config)
EOF

