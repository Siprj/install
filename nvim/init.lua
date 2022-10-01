local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
  vim.cmd [[packadd packer.nvim]]
end

require'packer'.init{
  auto_clean = true,
  compile_on_sync = true,
  auto_reload_compiled = true
}

require'packer'.startup(function(use)
  use{"wbthomason/packer.nvim"}
  use{"folke/tokyonight.nvim"}
  use{"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
  use{"p00f/nvim-ts-rainbow"}
  use{"kyazdani42/nvim-web-devicons"}
  use{"kyazdani42/nvim-tree.lua"}
  use{"nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
      }
    }
  }
  use{"hrsh7th/nvim-cmp", requires = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp"}}
  use{"nvim-lualine/lualine.nvim"}
  use{"lukas-reineke/indent-blankline.nvim"}
  use{"neovim/nvim-lspconfig"}
  use{"mickael-menu/zk-nvim"}
  use{"tpope/vim-fugitive"}
  use{"phaazon/hop.nvim"}
  use{"j-hui/fidget.nvim"}
  use{"https://git.sr.ht/~whynothugo/lsp_lines.nvim"}
  use{"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}

  if packer_bootstrap then
    require'packer'.sync()
  end
end)

if not packer_bootstrap then
  vim.g.mapleader = ","
  vim.keymap.set({"n", "v", "s", "o"}, ",,", ",")

  -- Sets how many lines of history VIM has to remember.
  vim.opt.history = 700
  -- Set to auto read when a file is changed from the outside
  vim.opt.autoread = true
  -- Turn of backups and swap files. We have git for these
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.swapfile = false
  -- Use fmt for prettier line formatting.
  vim.opt.formatprg = "fmt -w80"
  -- Don't put mode name (Insert, Replace or Visual) into the comand line. This
  -- information is supose to be in the status line anywway.
  vim.opt.showmode = false
  -- Additional 7 lines above and below cursor when scrolling. This allow me to
  -- see more cleary what I'm about to edit.
  vim.opt.scrolloff = 7
  vim.opt.number = true
  vim.opt.wildmode = "list:longest,full"

  -- Show trailing whitespace.
  vim.opt.list = true
  vim.opt.listchars = "tab:> ,trail:-,extends:>,precedes:<,nbsp:+"

  -- Movement accros lines, am I using it???
  -- vim.opt.whichwrap=<,>,h,l,b,s

  -- Ignore case when searching.
  vim.opt.ignorecase = true

  -- TODO: Do I really want this? Maybe it would be better to create function
  -- which will turn case sensitivity searches and then turns it back on.
  vim.opt.smartcase = true
  vim.opt.lazyredraw = true
  -- Show matching brackets when text indicator is over them.
  vim.opt.showmatch = true

  -- Use spaces instead of tabs.
  vim.opt.expandtab = true
  vim.opt.shiftwidth = 4
  vim.opt.tabstop = 4
  vim.opt.linebreak = true
  vim.opt.textwidth = 500
  vim.opt.mouse = "a"
  vim.opt.colorcolumn = "80"

  -- TODO: Configure fold level????
  -- set foldlevel=1

  -- vim.opt.shada:prepend("%")
  -- TODO: The last_edit function is missing
  local init_group_id = vim.api.nvim_create_augroup("last_edit", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = {"*"},
    group = init_group_id,
    callback = function() vim.fn.setpos(".", vim.fn.getpos("'\"")) end
  })

  function deleteTrailingWhitespaces()
    local view = vim.fn.winsaveview()
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.winrestview(view)
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "cpp", "java", "haskell", "javascript", "python", "elm", "rust", "lua"},
    group = init_group_id,
    callback = function() vim.api.nvim_create_autocmd("BufWritePre", { pattern = "<buffer>", callback = deleteTrailingWhitespaces }) end
  })

  vim.keymap.set({"n", "v", "s", "o"}, ",,", ",")

  -- Copy and paste to os clipboard.
  vim.keymap.set({"n", "x"}, "<leader>y", "\"+y")
  vim.keymap.set({"n", "x"}, "<leader>d", "\"+d")
  vim.keymap.set({"n", "x"}, "<leader>p", "\"+p")

  -- Treat long lines as break lines (useful when moving around in them)
  vim.keymap.set("n", "j", "gj")
  vim.keymap.set("n", "k", "gk")


  -- Toggle spell checking; equivalent of :setlocal spell!<CR>
  vim.keymap.set("n", "<leader>ss", function() vim.opt_local.spell = not vim.opt_local.spell:get() end)
  vim.keymap.set("n", "<leader><CR>", ":noh|hi Cursor guibg=red<CR>", { silent = true })

  -- tokyonight.nvim
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_enable_italic = 1
  vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer", "nerdtree"}
  vim.g.tokyonight_lualine_bold = 1
  vim.cmd "colorscheme tokyonight"

  -- nvim-treesitter and nvim-ts-rainbow
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
      enable = true,              -- false will disable the whole extension
      disable = {},  -- list of language that will be disabled
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    }
  }

  -- nvim-web-devicons
  require'nvim-web-devicons'.setup()

  -- nvim-tree
  local tree_callback = require'nvim-tree.config'.nvim_tree_callback
  require'nvim-tree'.setup{
    hijack_cursor       = true,
    view = {
      mappings = {
        list = {
          { key = "i", cb = tree_callback("vsplit") },
          { key = "s", cb = tree_callback("split") },
          { key = "t", cb = tree_callback("tabnew") }
        }
      },
    },
    actions = {
      open_file = {
        quit_on_open = true,
        resize_window = false
      }
    },
    update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = {},
    },
  }
  vim.keymap.set("n", "<leader>o", "<ESC>:NvimTreeToggle<CR>", { silent = true })

  -- telescope.nvim
  local telescope = require'telescope'
  local telescope_builtin = require'telescope.builtin'

  telescope.setup()
  telescope.load_extension("fzf")
  vim.keymap.set("n", "<leader><space>", telescope_builtin.find_files, { silent = true })
  vim.keymap.set("n", "<leader>t", telescope_builtin.builtin)
  vim.keymap.set("n", "<leader>b", telescope_builtin.buffers, { silent = true })
  vim.keymap.set("n", "<leader>tl", telescope_builtin.live_grep)
  vim.keymap.set("n", "<leader>tg", telescope_builtin.git_files)
  -- TODO: I could probably use telescope for LSP as well :thinking_face:
  local live_grep_options = { additional_args = function(opts) return {"--hidden"} end}
  vim.keymap.set("n", "<leader>gg", function() telescope_builtin.live_grep(live_grep_options) end)

  -- nvim-cmp
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  local cmp = require'cmp'
  cmp.setup{
    mapping = {

      -- ... Your other mappings ...
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      })
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      -- TODO: Add snippet source...
    },
  }

  -- lualine.nvim
  require'lualine'.setup{
    options = {
      theme = "tokyonight",
      section_separators = {"", ""},
      component_separators = {"", ""},
      icons_enabled = true
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "filename" },
      lualine_c = { { "diagnostics", sources = { "nvim_diagnostic" } } },
      lualine_x = { },
      lualine_y = { "encoding", "fileformat", "filetype" },
      lualine_z = { "progress", "location" }
    },
    inactive_sections = {
      lualine_a = {  },
      lualine_b = {  },
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {  },
      lualine_z = {   }
    },
    extensions = { "fzf" }
  }

  -- indent-blankline.nvim
  require'indent_blankline'.setup {
    char = "┆",
    show_first_indent_level = false,
    buftype_exclude = {"terminal", "help"},
    buftype = {
      "vim",
      "rust",
      "haskell",
      "c",
      "cpp",
      "java",
      "javascript",
      "python",
      "elm",
      "lua"},
    show_trailing_blankline_indent = true,
  }

  -- nvim-lspconfig
  local lsp_config = require'lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_nvim_lsp = require'cmp_nvim_lsp'
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

  lsp_config.hls.setup{on_attach=on_attach, capabilities = capabilities, cmd = {"haskell-language-server-wrapper", "--lsp"}}
  lsp_config.rust_analyzer.setup{on_attach=on_attach, capabilities = capabilities}
  lsp_config.elmls.setup{on_attach=on_attach, capabilities = capabilities}

  vim.keymap.set({"n"}, "K", vim.lsp.buf.hover)
  vim.keymap.set({"n"}, "gd", vim.lsp.buf.definition)

  vim.keymap.set({"n"}, "[c", vim.diagnostic.goto_prev)
  vim.keymap.set({"n"}, "]c", vim.diagnostic.goto_next)

  vim.keymap.set({"n"}, "<leader>ls", vim.lsp.buf.signature_help)
  vim.keymap.set({"v"}, "<leader>la", vim.lsp.buf.range_code_action)
  vim.keymap.set({"n"}, "<leader>la", vim.lsp.buf.code_action)
  vim.keymap.set({"n"}, "<leader>lr", vim.lsp.buf.rename)
  vim.keymap.set({"n"}, "<leader>lt", vim.lsp.buf.references)

  vim.keymap.set({"n"}, "<leader>cd", vim.diagnostic.open_float)
  vim.keymap.set({"n"}, "<leader>li", vim.lsp.buf.implementation)
  vim.keymap.set({"n"}, "<leader>lD", vim.lsp.buf.type_definition)
  vim.keymap.set({"n"}, "<leader>l1", vim.lsp.buf.document_symbol)
  vim.keymap.set({"n"}, "<leader>lw", vim.lsp.buf.workspace_symbol)
  vim.keymap.set({"n"}, "<leader>ld", vim.lsp.buf.declaration)
  vim.keymap.set({"n"}, "<leader>cd", vim.diagnostic.open_float)

  -- Update time for CursorHold/I is derived from the option `updatetime`
  -- which sets the time to wait before the swap file is written. But I don't
  -- use swap files so it is OK to set it to what ever
  vim.opt.updatetime = 200
  vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    callback = function()
      if vim.tbl_count(vim.lsp.get_active_clients()) ~= 0 then
        vim.lsp.buf.document_highlight()
      end
    end
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = vim.lsp.buf.clear_references
  })

  -- zk-nvim
  require'zk'.setup({
    picker = "telescope",
    lsp = {
      config = {
        cmd = { "zk", "lsp" },
        name = "zk",
      },
      auto_attach = {
        enabled = true,
        filetypes = { "markdown" },
      },
    },
  })
  vim.keymap.set({"n"}, "<leader>zn", ":ZkNew<CR>")
  vim.keymap.set({"n"}, "<leader>zo", ":ZkNotes<CR>")
  vim.keymap.set({"v"}, "<leader>zft", ":'<,'>ZkNewFromTitleSelection<CR>")
  vim.keymap.set({"v"}, "<leader>zfc", ":'<,'>ZkNewFromContentSelection<CR>")
  vim.keymap.set({"n"}, "<leader>zb", ":ZkBacklinks<CR>")
  vim.keymap.set({"n"}, "<leader>zl", ":ZkLinks<CR>")
  vim.keymap.set({"n"}, "<leader>zt", ":ZkTags<CR>")

  -- vim-fugitive
  vim.keymap.set({"n"}, "<leader>gb", function() vim.cmd("Git blame") end)

  -- hop.nvim
  local hop = require'hop'
  hop.setup()
  vim.keymap.set({"n", "x", "o", "v"}, "f", require'hop'.hint_char1)
  vim.keymap.set({"n", "x", "o", "v"}, "F", require'hop'.hint_char1)

  -- fidget; show nice LSP status outside the status line
  require'fidget'.setup{}

  -- ls_lines.nvim
  require'lsp_lines'.setup()

  -- todo-comments.nvim
  local todo_comments_config = {
    signs = true, -- show icons in the signs column
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",
      }
    }
  }
  require'todo-comments'.setup(todo_comments_config)
end
