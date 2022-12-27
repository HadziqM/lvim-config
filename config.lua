lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "alduin"
lvim.transparent_window = true
lvim.use_icons = true

vim.opt.relativenumber = false

-- need to instal clipboard provider (i m using xclip for linux)
-- note that with this you could paste on insert mode with terminal keybind (<C-S-v> for me)
vim.opt.clipboard = "unnamedplus"


lvim.leader = "space"

-- <M> is alt
-- <S> is shift
-- <C> is Ctrl
-- <cr> is enter
-- run :map to see all keymap

-- save and quit
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-q>"] = ":wq<cr>"
lvim.keys.normal_mode["<C-S-q>"]=":q!<cr>"

-- restart lsp server when there is touble running
lvim.keys.normal_mode["<C-;>"]=":LspStart<cr>"


-- buffer management
-- split screen
lvim.keys.normal_mode["|"]=":vsplit<cr>"
lvim.keys.normal_mode["-"]=":split<cr>"
lvim.keys.normal_mode["<f2>"]=":on<cr>"
-- buffer action
lvim.keys.normal_mode["<Tab>"] = ":bnext<cr>"
lvim.keys.normal_mode["<S-Tab>"] = ":bd<cr>"
lvim.keys.normal_mode["<C-Tab>"] = ":bprev<cr>"
-- screen action
lvim.keys.normal_mode["<C-S-Right>"]=":vertical resize +2<cr>"
lvim.keys.normal_mode["<C-S-Left>"]=":vertical resize -2<cr>"
lvim.keys.normal_mode["<C-S-Down>"]=":resize +2<cr>"
lvim.keys.normal_mode["<C-S-Up>"]=":resize -2<cr>"
lvim.keys.normal_mode["<C-Right>"]= "<C-W><Right>"
lvim.keys.normal_mode["<C-Left>"]= "<C-W><Left>"
lvim.keys.normal_mode["<C-Down>"]= "<C-W><Down>"
lvim.keys.normal_mode["<C-Up>"]= "<C-W><Up>"


-- <leader>e for toogle Nvim-Tree
-- <leader>\ or <M-1> or <M-2> dst. to toogle terminal
-- <leader>f to toogle Telecope finding file
-- <leader>/ in visual or normal mode to toogle comment

-- mimic vscode text move and copy line that i made myself

lvim.keys.normal_mode['<M-Up>'] = ":m .-2<cr>=="
lvim.keys.normal_mode['<M-Down>'] = ":m .+1<cr>=="
lvim.keys.normal_mode["<M-S-Down>"]="yyp<end>"
lvim.keys.normal_mode["<M-S-Up>"]="yyP<end>"
lvim.keys.visual_mode["<M-Up>"]=":m '<-2<cr>gv-gv"
lvim.keys.visual_mode["<M-Down>"]=":m '>+1<cr>gv-gv"
lvim.keys.visual_mode["<M-S-Down>"]="yP`[gv-gv"
lvim.keys.visual_mode["<M-S-Up>"]="y`]p`]gv-gv"

-- with this we got almost like vscode mapping, except the multiple cursor

-- # how to mimic vscode ctrl-d and the multiple cursor actions

-- ## change highlighted text
-- run search by "/item_search<cr>"
-- change the first or any order highlighted item by "cgn" and go normal mode
-- make next highlighted item same edit with "."
-- skip editing and move next with "n"
-- <leader>h to stop hightlight

-- ## delete highlighted text
-- same with change but using "gn" for selected action
-- then "d" for delete highlighted
-- "n" then "." to delete next item

-- ** alternatively you could use ":%s/item_search/item_changed/g" to change or delete all

-- ## mimic multiple cursor with visual block (change same line position)
-- go to visual mode by <C-v>
-- add line by arrow key or "j" or "k"
-- press <S-i> to go insert mode on first item
-- <esc> to go normal mode, and all the line automatically change

-- ## change multiple line in different position
-- this only possible by recording macro on one line then replay it on other line
-- start recording keystrokes and command by input "qq"
-- end the record with "q"
-- then replay the recorded by "@q"


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
-- this for treesitter colouring your text
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "go",
  "svelte",
  "toml"
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.rainbow.enable= true



-- custom plugins and its config

lvim.plugins = {
  {
   "simrat39/rust-tools.nvim",
    config = function()
      require("rust-tools").setup {
        tools = {
          executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
          reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<-",
            other_hints_prefix = "=>",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          hover_actions = {
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
            auto_focus = true,
          },
        },
        server = {
          on_init = require("lvim.lsp").common_on_init,
          on_attach = function(client, bufnr)
            require("lvim.lsp").common_on_attach(client, bufnr)
            local rt = require "rust-tools"
            -- Hover actions
            vim.keymap.set("n", "<C-a>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<C-q>", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },
  {"MunifTanjim/prettier.nvim",
    config = function ()
      require("prettier"):setup({
        bin = 'prettier', -- or `'prettierd'` (v0.22+)
         filetypes = {
           "css",
           "graphql",
           "html",
           "javascript",
           "javascriptreact",
           "json",
           "less",
           "markdown",
           "scss",
           "rust",
           "go",
           "typescript",
           "typescriptreact",
           "yaml",
         },
      })
    end},
   {"andweeb/presence.nvim",
    config = function()
    require("presence"):setup({
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})
    end},
  {"windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup{
        filetypes = {'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
    'xml',
    'php',
    'markdown',
    'glimmer','handlebars','hbs'},
        skip_tags = {
  'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
  'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'}
      }
    end},
  {"AlessandroYorba/Alduin"},
  {"p00f/nvim-ts-rainbow"},
}
