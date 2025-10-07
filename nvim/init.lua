local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
-- The leader mapping needs to be before the lazy.nvim is called so the keys
-- are set correctly.
vim.g.mapleader = ","
vim.keymap.set({"n", "v", "s", "o"}, ",,", ",")
vim.opt.history = 500
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
vim.opt.cursorline = true
-- Additional 7 lines above and below cursor when scrolling. This allow me to
-- see more cleary what I'm about to edit.
vim.opt.scrolloff = 7
vim.opt.number = true
vim.opt.wildmode = "list:longest,full"
-- Show trailing whitespace.
vim.opt.list = true
vim.opt.listchars = "tab:> ,trail:-,extends:>,precedes:<,nbsp:+"
-- Ignore case when searching.
vim.opt.ignorecase = true
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
vim.opt.updatetime = 200

local kinds = {
  Array = " ",
  Boolean = " ",
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Namespace = " ",
  Null = " ",
  Number = " ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  String = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}
-- Copy and paste to os clipboard.
vim.keymap.set({"n", "x"}, "<leader>y", "\"+y")
vim.keymap.set({"n", "x"}, "<leader>d", "\"+d")
vim.keymap.set({"n", "x"}, "<leader>p", "\"+p")

-- Toggle spell checking; equivalent of :setlocal spell!<CR>
vim.keymap.set("n", "<leader>ss", function() vim.opt.spell = not vim.opt.spell:get() end)

if vim.g.vscode then
  -- VSCode configurations
  vim.keymap.set({"n"}, "<leader>la", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")

else

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

local catppuccin = {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = {enabled = true},
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = {"undercurl"},
            hints = {"undercurl"},
            warnings = {"undercurl"},
            information = {"undercurl"},
          },
        },
        navic = {enabled = true, custom_bg = "lualine"},
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
    }
  }
}


local tokyonight = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = { style = "moon" },
}


-- TODO: Close after picking file
local neo_tree = {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
          require 'window-picker'.setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', "quickfix" },
              },
          },
        })
        end,
      },
    },
    keys = {
      {"<leader>o", "<CMD>Neotree action=focus reveal toggle=true<CR>", silent = true, mode = "n"},
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
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
        event_handlers = {
          {
            event = "file_opened",
            handler = function()
              require("neo-tree.command").execute({ action = "close" })
            end
          },
        }
      })
    end,
}


local luasnip = {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        return require'luasnip'.jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true, silent = true, mode = "i",
    },
    { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
  config = function()
    local luasnip = require'luasnip'
    local types = require'luasnip.util.types'
    luasnip.config.set_config{
      history = true,
      -- Update more often, :h events for more info.
      update_events = "TextChanged,TextChangedI",
      delete_check_events = "TextChanged",
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
    luasnip.add_snippets("rust", {
      s("derive", {
        t("#[derive("),
        i(0,"name"),
        t(")]"),
      }),
    })
  end,
}


local nvim_cmp = {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    return {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = function(_, item)
          local icons = kinds          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          return item
        end,
      },
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      sorting = defaults.sorting,
    }
  end,
}


-- TODO: Keybindings with telescope???
local nvim_lspconfig = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      {"folke/neodev.nvim", opts = {}},
      "nvim-telescope/telescope.nvim",
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    },
  },
  config = function()
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.INFO] = '',
          [vim.diagnostic.severity.HINT] = '󰌵',
        },
      }
    })


    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return; end
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, {bufnr= bufnr})
        end

        if client.server_capabilities.codeLensProvider then
          local codelens = vim.api.nvim_create_augroup("LSPCodeLens", {clear = true})
          vim.api.nvim_create_autocmd({"BufEnter"}, {
            group = codelens,
            callback = function()
              vim.lsp.codelens.refresh({bufnr = 0})
            end,
            buffer = bufnr,
            once = true,
          })
          vim.api.nvim_create_autocmd({"BufWritePost", "CursorHold"}, {
            group = codelens,
            callback = function()
              vim.lsp.codelens.refresh({bufnr = 0})
            end,
            buffer = bufnr,
          })
        end

      end,
    })

    local diagnostic_prefix = "●"
    if vim.fn.has("nvim-0.10.0") ~= 0 then
      diagnostic_prefix = function(diagnostic)
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          return " "
        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
          return " "
        elseif diagnostic.severity == vim.diagnostic.severity.INFO then
          return " "
        elseif diagnostic.severity == vim.diagnostic.severity.HINT then
          return " "
        else
          return ""
        end
      end
    end

    vim.diagnostic.config({
      severity_sort = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = diagnostic_prefix
      }
    })

    local cmp_capabilities = require'cmp_nvim_lsp'.default_capabilities()
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_capabilities
    )
    local on_attach = function(client, bufnr)
      if client.server_capabilities.code_lens then
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

    vim.keymap.set({"n"}, "K", vim.lsp.buf.hover)
    vim.keymap.set({"n"}, "gd", function() require'telescope.builtin'.lsp_definitions() end)

    vim.keymap.set({"n"}, "[c", vim.diagnostic.goto_prev)
    vim.keymap.set({"n"}, "]c", vim.diagnostic.goto_next)

    vim.keymap.set({"n"}, "<leader>ls", vim.lsp.buf.signature_help)
    -- TODO: Do I want to use this actions-preview???
    --vim.keymap.set({"n"}, "<leader>la", function() require("actions-preview").code_actions() end)
    vim.keymap.set({"n"}, "<leader>la", vim.lsp.buf.code_action)
    vim.keymap.set({"n"}, "<leader>lr", vim.lsp.buf.rename)
    vim.keymap.set({"n"}, "<leader>lt", function() require'telescope.builtin'.lsp_references() end)

    vim.keymap.set({"n"}, "<leader>li", function() require'telescope.builtin'.lsp_implementations() end)
    vim.keymap.set({"n"}, "<leader>lD", function() require'telescope.builtin'.lsp_type_definitions() end)
    vim.keymap.set({"n"}, "<leader>l1", function() require'telescope.builtin'.lsp_document_symbols() end)
    vim.keymap.set({"n"}, "<leader>lw", function() require'telescope.builtin'.lsp_workspace_symbols() end)
    vim.keymap.set({"n"}, "<leader>ld", function() require'telescope.builtin'.lsp_definitions() end)
    vim.keymap.set({"n"}, "<leader>ld", function() require'telescope.builtin'.lsp_definitions() end)
    vim.keymap.set({"n"}, "<leader>ll", function() vim.diagnostic.config{virtual_text = not require'lsp_lines'.toggle()} end)

    vim.lsp.config('hls', {
      on_attach=on_attach,
      capabilities = capabilities,
      cmd = {"run-hls.sh", "--lsp"}
    })
    vim.lsp.config('rust_analyzer', {
      on_attach=on_attach,
      capabilities = capabilities,
      settings = { ["rust-analyzer"] = {
          check = {
            command = "clippy"
          }
        }
      },
      commands = {
        ExpandMacro = { function() vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), vim.print) end }
      }
    })
    vim.lsp.config('elmls', {
      on_attach=on_attach,
      capabilities = capabilities,
      cmd = {"npx", "elm-language-server"}
    })

    require("neodev").setup()
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    })
    vim.lsp.enable('clangd')
    vim.lsp.enable('elmsl')
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('hls')
  end,
}


-- TODO: Keybindings
local telescope = {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies =
    { "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      },
      "AckslD/nvim-neoclip.lua",
    },
  version = false,
  keys = {
    {"<leader><space>", function() require'telescope.builtin'.find_files() end, silent=true, mode = "n" },
    {"<leader>t", function() require'telescope.builtin'.builtin() end, silent=true, mode = "n" },
    {"<leader>b", function() require'telescope.builtin'.buffers() end, silent=true, mode = "n" },
    {"<leader>tl", function() require'telescope.builtin'.live_grep() end, silent=true, mode = "n" },
    {"<leader>tg", function() require'telescope.builtin'.git_files() end, silent=true, mode = "n"},
    {"<leader>tc", "<CMD>Telescope neoclip", silent = true, mode = "n"},
    {"<leader>gg", function() require'telescope.builtin'.live_grep({ additional_args = function() return {"--hidden"} end}) end, silent = true, mode = "n"},
  },
  config = function()
    local telescope = require'telescope'
    telescope.setup({})
    telescope.load_extension("fzf")
    telescope.load_extension("neoclip")
  end
}


local dressing = {"stevearc/dressing.nvim"}


local lualine = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        theme = "auto",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
          },
        },
        lualine_x = {
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = {fg = string.format("#%06x", vim.api.nvim_get_hl(0, {name = "Debug"}).fg or 0)}
          },
          {require("lazy.status").updates, cond = require("lazy.status").has_updates, color = {fg = string.format("#%06x", vim.api.nvim_get_hl(0, {name = "Special"}).fg)}},
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
          },
        },
        lualine_y = {"encoding", "fileformat", "filetype"},
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
      extensions = {"neo-tree", "lazy"},
    }
  end,
}


local indent_blankline = {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = { char = "┆" },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "neo-tree",
        "Trouble",
        "lazy",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  main = "ibl",
}


local indentscope = {
  "echasnovski/mini.indentscope",
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    return {
      -- symbol = "▏",
      symbol = "┆",
      options = { try_as_border = true },
      draw = {animation = require'mini.indentscope'.gen_animation.none()},
    }
  end,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "toggleterm",
        "lazyterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}


local navic = {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true

      local navic_group_id = vim.api.nvim_create_augroup("NavicLspAttach", {clear = false})
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.documentSymbolProvider then
            require'nvim-navic'.attach(client, bufnr)
          end
        end,
        group = navic_group_id
      })
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = kinds,
      }
    end,
  }


-- TODO: Keybindings
local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  lazy = false,
  branch = 'main',
  dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects",
      branch = 'main',
      }},
  cmd = {"TSUpdateSync"},
  --keys = {
  --  { "<c-space>", desc = "Increment selection" },
  --  { "<bs>", desc = "Decrement selection", mode = "x" },
  --},
  config = function()
    require'nvim-treesitter'.setup{
      highlight = {enable = true},
      indent = {enable = true},
      incremental_selection = {
        enable = true, keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = {query = "@class.outer", desc = "Next class start"},
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = {query = "@scope", query_group = "locals", desc = "Next scope"},
            ["]z"] = {query = "@fold", query_group = "folds", desc = "Next fold"},
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
          goto_next = {
            ["]d"] = "@conditional.outer",
          },
          goto_previous = {
            ["[d"] = "@conditional.outer",
          }
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          floating_preview_opts = {},
          peek_definition_code = {
            ["<leader>df"] = "@function.outer",
            ["<leader>dF"] = "@class.outer",
          },
        },
      },
    }
    require'nvim-treesitter'.install("all")
  end,
}


local illuminate = {
  "RRethy/vim-illuminate",
  event = {"BufReadPost", "BufNewFile"},
  config = function()
    require("illuminate").configure{
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {providers = {"lsp"}}
    }

    local function map(key, dir, buffer)
      vim.keymap.set("n", key, function()
        require("illuminate")["goto_" .. dir .. "_reference"](false)
      end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
    end

    map("]]", "next")
    map("[[", "prev")

    -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        map("]]", "next", buffer)
        map("[[", "prev", buffer)
      end,
    })
  end,
  keys = {
    {"]]", desc = "Next Reference"},
    {"[[", desc = "Prev Reference"},
  },
}

local trouble = {
  "folke/trouble.nvim",
  cmd = {"TroubleToggle", "Trouble"},
  opts = {use_diagnostic_signs = true},
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").previous({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous trouble/quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next trouble/quickfix item",
    },
  },
}


local todo_comments = {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile" },
  config = true,
  opts = {
    signs = true,
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
  },
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
}


--TODO: key bindings
local ts_context_commentstring = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
}
local mini_comment = {
  "echasnovski/mini.comment",
  event = "VeryLazy",
  opts = {
    options = {
      custom_commentstring = function()
        return require'ts_context_commentstring.internal'.calculate_commentstring() or vim.bo.commentstring
      end,
    },
  },
}


local hop = {
  'smoka7/hop.nvim',
  version = "*",
  opts = {},
  keys = {
    {"f", function() require'hop'.hint_char1({}) end, desc = "Next todo comment", mode = {"n", "x", "o", "v"}},
    {"F", function() require'hop'.hint_char1({}) end, desc = "Previous todo comment", mode = {"n", "x", "o", "v"}},
  },
}


local zk_nvim = {
  "mickael-menu/zk-nvim",
  config = function ()
    local cmp_capabilities = require'cmp_nvim_lsp'.default_capabilities()
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_capabilities
    )
    require'zk'.setup{
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
    }
  end,
  keys = {
    {"<leader>znv", "<CMD>ZkNew {dir = \"videos\"}<CR>", mode = "n"},
    {"<leader>znb", "<CMD>ZkNew {dir = \"books\"}<CR>", mode = "n"},
    {"<leader>zna", "<CMD>ZkNew {dir = \"articles\"}<CR>", mode = "n"},
    {"<leader>znt", "<CMD>ZkNew {dir = \"tools\"}<CR>", mode = "n"},
    {"<leader>znn", "<CMD>ZkNew<CR>", mode = "n"},
    {"<leader>zn", "<CMD>ZkNew<CR>", mode = "n"},
    {"<leader>zo", "<CMD>ZkNotes<CR>", mode = "n"},
    {"<leader>zft", "<CMD>'<,'>ZkNewFromTitleSelection<CR>", mode = "v"},
    {"<leader>zfc", "<CMD>'<,'>ZkNewFromContentSelection<CR>", mode = "v"},
    {"<leader>zb", "<CMD>ZkBacklinks<CR>", mode = "n"},
    {"<leader>zl", "<CMD>ZkLinks<CR>", mode = "n"},
    {"<leader>zt", "<CMD>ZkTags<CR>", mode = "n"},
  }
}


local fugitive = {
  "tpope/vim-fugitive",
  lazy = false,
  keys = {{"<leader>gb", "<CMD>Git blame<CR>", mode = "n"}}
}


local fidget = {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {},
}


local markdown_preview = {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
}


local copilot = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<C-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    })
  end,
}

local outline = {
  "hedyhli/outline.nvim",
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set("n", "<leader>lo", "<cmd>Outline<CR>",
      { desc = "Toggle Outline" })

    require("outline").setup {
      -- Your setup opts here (leave empty to use defaults)
    }
  end,
}

local plugins = {
  catppuccin,
  tokyonight,
  neo_tree,
  luasnip,
  nvim_cmp,
  nvim_lspconfig,
  telescope,
  dressing,
  lualine,
  indent_blankline,
  indentscope,
  navic,
  treesitter,
  illuminate,
  trouble,
  todo_comments,
  ts_context_commentstring,
  mini_comment,
  hop,
  zk_nvim,
  fugitive,
  fidget,
  markdown_preview,
  copilot,
  outline
}

require("lazy").setup(plugins)

vim.cmd "colorscheme catppuccin"

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rust', 'haskell', 'typescript', 'javascript', 'zig' },
    callback = function()
      -- syntax highlighting, provided by Neovim
      vim.treesitter.start()
      -- folds, provided by Neovim
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- indentation, provided by nvim-treesitter
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
local init_group_id = vim.api.nvim_create_augroup("init_group", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = {"*"},
  group = init_group_id,
  callback = function() vim.fn.setpos(".", vim.fn.getpos("'\"")) end
})

local deleteTrailingWhitespaces = function()
  local view = vim.fn.winsaveview()
  vim.cmd [[%s/\s\+$//e]]
  vim.fn.winrestview(view)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "java", "haskell", "javascript", "python", "elm", "rust", "lua", "cabal", "yaml", "dockerfile"},
  group = init_group_id,
  callback = function() vim.api.nvim_create_autocmd("BufWritePre", { pattern = "<buffer>", callback = deleteTrailingWhitespaces }) end
})

local zk_home = vim.fn.expand('*$HOME/Dropbox/notes/*')
-- Load zk when entering the notes directory.
vim.api.nvim_create_autocmd("BufRead", {
  pattern = {zk_home},
  group = init_group_id,
  callback = function() require'zk' end
})


-- Treat long lines as break lines (useful when moving around in them)
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")


vim.keymap.set("n", "<leader><CR>", ":noh|hi Cursor guibg=red<CR>", { silent = true })

end
