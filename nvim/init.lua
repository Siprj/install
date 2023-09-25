local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
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
  use{"catppuccin/nvim", as = "catppuccin" }
  use{"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
  use{"https://gitlab.com/HiPhish/rainbow-delimiters.nvim"}
  use{"nvim-tree/nvim-web-devicons"}
  use{"nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
      }
    }
  }
  use{"hrsh7th/nvim-cmp", requires = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lsp-signature-help", "saadparwaiz1/cmp_luasnip"}}
  use{"nvim-lualine/lualine.nvim"}
  use{"lukas-reineke/indent-blankline.nvim"}
  use{"neovim/nvim-lspconfig"}
  use{"mickael-menu/zk-nvim"}
  use{"tpope/vim-fugitive"}
  use{"phaazon/hop.nvim"}
  use{"j-hui/fidget.nvim"}
  use{"https://git.sr.ht/~whynothugo/lsp_lines.nvim"}
  use{"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
  use{"L3MON4D3/LuaSnip"}
  -- For now lets use some snippet collection
  use{"AckslD/nvim-neoclip.lua", requires = {"nvim-telescope/telescope.nvim"}}

  use{"kosayoda/nvim-lightbulb"}
  use{"aznhe21/actions-preview.nvim"}
  use{"folke/noice.nvim"}
  use{"MunifTanjim/nui.nvim"}
  use{"folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons"}
  use{"nvim-neo-tree/neo-tree.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      's1n7ax/nvim-window-picker',
    }
  }

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
  --vim.opt.lazyredraw = true
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

  local init_group_id = vim.api.nvim_create_augroup("init_group", { clear = true })
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
    pattern = {"c", "cpp", "java", "haskell", "javascript", "python", "elm", "rust", "lua", "cabal", "yaml", "dockerfile"},
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

  require("catppuccin").setup({flavour = "mocha"})
  vim.cmd "colorscheme catppuccin"

  vim.fn.sign_define("DiagnosticSignError",
    {text = " ", texthl = "DiagnosticSignError"})
  vim.fn.sign_define("DiagnosticSignWarn",
    {text = " ", texthl = "DiagnosticSignWarn"})
  vim.fn.sign_define("DiagnosticSignInfo",
    {text = " ", texthl = "DiagnosticSignInfo"})
  vim.fn.sign_define("DiagnosticSignHint",
    {text = "󰌵", texthl = "DiagnosticSignHint"})

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
  }

  -- nvim-web-devicons
  require'nvim-web-devicons'.setup()

--  -- nvim-tree
--  local nvim_tree_api = require'nvim-tree.api'
--  require'nvim-tree'.setup{
--    hijack_cursor       = true,
--    view = {
--      mappings = {
--        list = {
--          { key = "i", cb = nvim_tree_api.node.open.vertical },
--          { key = "s", cb = nvim_tree_api.node.open.horizontal },
--          { key = "t", cb = nvim_tree_api.node.open.tab },
--          { key = "o", cb = nvim_tree_api.node.run.system },
--        }
--      },
--    },
--    actions = {
--      open_file = {
--        quit_on_open = true,
--        resize_window = false
--      }
--    },
--    update_focused_file = {
--      enable = true,
--      update_root = false,
--      ignore_list = {},
--    },
--  }

  -- If you want icons for diagnostic errors, you'll need to define them somewhere:

      require("neo-tree").setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted   = "✖",-- this can only be used in the git_status source
              renamed   = "󰁕",-- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            }
          }
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-custom-commands-global`
        commands = {},
        window = {
          position = "left",
          width = 40,
          mappings = {
            ["<space>"] = {
                "toggle_node",
                nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open_with_window_picker",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none" -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          }
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = false, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                                  -- in whatever position is specified in window.position
                                -- "open_current",  -- netrw disabled, opening a directory opens within the
                                                  -- window like netrw would, regardless of window.position
                                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                                          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["og"] = { "order_by_git_status", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
            },
          },

          commands = {} -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --              -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            }
          },
        },
      })

  vim.keymap.set("n", "<leader>o", "<ESC>:Neotree action=focus reveal toggle=true<CR>", { silent = true })

  -- telescope.nvim
  local telescope = require'telescope'
  local telescope_builtin = require'telescope.builtin'

  telescope.setup()
  telescope.load_extension("fzf")
  telescope.load_extension("neoclip")
  telescope.load_extension("noice")
  vim.keymap.set("n", "<leader><space>", telescope_builtin.find_files, { silent = true })
  vim.keymap.set("n", "<leader>t", telescope_builtin.builtin)
  vim.keymap.set("n", "<leader>b", telescope_builtin.buffers, { silent = true })
  vim.keymap.set("n", "<leader>tl", telescope_builtin.live_grep)
  vim.keymap.set("n", "<leader>tg", telescope_builtin.git_files)
  local live_grep_options = { additional_args = function(opts) return {"--hidden"} end}
  vim.keymap.set("n", "<leader>gg", function() telescope_builtin.live_grep(live_grep_options) end)

  -- LuaSnip
  local luasnip = require'luasnip'
  local types = require'luasnip.util.types'

  luasnip.config.set_config{
    history = true,
    -- Update more often, :h events for more info.
    update_events = "TextChanged,TextChangedI",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<-", "Error" } },
        },
      },
    },
  }
  local s = luasnip.snippet
  local p = require("luasnip.extras").partial
  local t = luasnip.text_node
  local i = luasnip.insert_node
  luasnip.add_snippets("all", {
    s("date", p(os.date, "%Y-%m-%d")),
  })
  local get_haskell_module_path = function()
    return vim.fn.substitute(vim.fn.substitute(vim.fn.expand("%:r"), "/",".","g"), "^\\%(\\l*\\.\\)\\?", "", "")
  end
  luasnip.add_snippets("haskell", {
    s("lang", {
      t("{-# LANGUAGE "),
      i(0,"OverloadedStrings"),
      t(" #-}"),
    }),
    s("ghc", {
      t("{-# OPTIONS_GHC "),
      i(0,"-fno-warn-unused-imports"),
      t(" #-}"),
    }),
    s("inline", {
      t("{-# INLINE "),
      i(0,"name"),
      t(" #-}"),
    }),
    s("module", {
      t("module "),
      p(get_haskell_module_path),
      t({"", "  (", "  )", "where", ""}),
    }),
  })

  -- nvim-cmp
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  local cmp = require'cmp'
  cmp.setup{
    mapping = {

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
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
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "buffer" },
    }),
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
  local cmp_nvim_lsp = require'cmp_nvim_lsp'
  local capabilities = cmp_nvim_lsp.default_capabilities()
  local on_attach = function(client, bufnr)
    --- Only Neovim 0.7
    if client.resolved_capabilities.code_lens then
      local codelens = vim.api.nvim_create_augroup(
        'LSPCodeLens',
        { clear = true }
      )
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        group = codelens,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
        buffer = bufnr,
        once = true,
      })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold' }, {
        group = codelens,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
        buffer = bufnr,
      })
    end
  end

  lsp_config.hls.setup{
    on_attach=on_attach,
    capabilities = capabilities,
    cmd = {"run-hls.sh", "--lsp"}
  }
  lsp_config.rust_analyzer.setup{on_attach=on_attach, capabilities = capabilities}
  lsp_config.elmls.setup{
    on_attach=on_attach,
    capabilities = capabilities,
    cmd = {"npx", "elm-language-server"}
  }

  vim.keymap.set({"n"}, "K", vim.lsp.buf.hover)
  vim.keymap.set({"n"}, "gd", telescope_builtin.lsp_definitions)

  vim.keymap.set({"n"}, "[c", vim.diagnostic.goto_prev)
  vim.keymap.set({"n"}, "]c", vim.diagnostic.goto_next)

  vim.keymap.set({"n"}, "<leader>ls", vim.lsp.buf.signature_help)
  vim.keymap.set({"n"}, "<leader>la", require("actions-preview").code_actions)
  vim.keymap.set({"n"}, "<leader>lr", vim.lsp.buf.rename)
  vim.keymap.set({"n"}, "<leader>lt", telescope_builtin.lsp_references)

  vim.keymap.set({"n"}, "<leader>li", telescope_builtin.lsp_implementations)
  vim.keymap.set({"n"}, "<leader>lD", telescope_builtin.lsp_type_definitions)
  vim.keymap.set({"n"}, "<leader>l1", telescope_builtin.lsp_document_symbols)
  vim.keymap.set({"n"}, "<leader>lw", telescope_builtin.lsp_workspace_symbols)
  vim.keymap.set({"n"}, "<leader>ld", telescope_builtin.lsp_definitions)
  -- TODO: look into codelens a bit.

  -- Update time for CursorHold/I is derived from the option `updatetime`
  -- which sets the time to wait before the swap file is written. But I don't
  -- use swap files so it is OK to set it to what ever
  vim.opt.updatetime = 200

  vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    callback = function()
      local clients = vim.lsp.get_active_clients()
      local has_capability = false;
      for k, v in pairs(clients) do
        has_capability = has_capability or v.server_capabilities.documentHighlightProvider
      end
      if has_capability then
        vim.lsp.buf.document_highlight()
        require'nvim-lightbulb'.update_lightbulb()
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
        capabilities = capabilities
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

  function toggle_diagnostics()
    vim.diagnostic.config{ virtual_text = not require'lsp_lines'.toggle() }
  end
  vim.keymap.set({"n"}, "<leader>ll", toggle_diagnostics)

  require'trouble'.setup()

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

  -- nvim-neoclip.lua
  require'neoclip'.setup()
  vim.keymap.set({"n"}, "<leader>n", ":Telescope neoclip<CR>")
  vim.keymap.set({"v"}, "<leader>n", ":Telescope neoclip<CR>")

  -- noice.nvim
  require'noice'.setup({
    lsp = {
      progress = {enabled = false},
      hover = {enabled = false},
      signature = {enabled = false},
    },
  })
end
