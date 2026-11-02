-- FIX: Auto-create undo directory to prevent E828 error
local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- ==========================================================================
-- EDITOR OPTIONS
-- ==========================================================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.swapfile = false

-- Leaders must be set BEFORE lazy.nvim loads
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ==========================================================================
-- LSP ON_ATTACH (defined early so plugin specs can reference it)
-- ==========================================================================
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>fm', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

-- ==========================================================================
-- PLUGIN MANAGER (LAZY.NVIM) BOOTSTRAP
-- ==========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "nvim-lualine/lualine.nvim",
  "nvim-tree/nvim-web-devicons",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  "lewis6991/gitsigns.nvim",
  "windwp/nvim-autopairs",
  "numToStr/Comment.nvim",
  "folke/which-key.nvim",
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { desc = "Toggle File Explorer" })
      vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { desc = "Focus File Explorer" })
    end,
  },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "nvim-telescope/telescope-ui-select.nvim",
  "akinsho/bufferline.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "neovim/nvim-lspconfig",
  "nvimtools/none-ls.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "tpope/vim-fugitive",
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    event = { "CmdlineEnter" },
    build = ":lua require('go.install').update_all_sync()",
    config = function()
      require("go").setup({
        lsp_inlay_hints = { enable = false },
        lsp_cfg = true,
        lsp_on_attach = on_attach,
      })
      local grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        group = grp,
        callback = function()
          require("go.format").goimports()
        end,
      })
    end,
  },
})

-- ==========================================================================
-- DYNAMIC THEME LOGIC
-- ==========================================================================
_G.reload_matugen_colors = function()
  -- vim.schedule ensures this massive UI update runs safely on the main event loop
  vim.schedule(function()
    -- FIX: Prevent warning on first lazy.nvim run before Catppuccin is downloaded
    local check_cat_installed = pcall(require, "catppuccin")
    if not check_cat_installed then
      return
    end

    local matugen_path = vim.fn.stdpath("config") .. "/matugen_colors.lua"
    local overrides = {}

    if vim.fn.filereadable(matugen_path) == 1 then
      local chunk = loadfile(matugen_path)
      if chunk then
        local colors = chunk()
        if type(colors) == "table" then
          overrides = { all = colors, mocha = colors }
        end
      end
    end

    -- FIX: Only clear catppuccin. Do NOT clear lualine, or it will leak highlight groups!
    for k, _ in pairs(package.loaded) do
      if k:match("^catppuccin") then
        package.loaded[k] = nil
      end
    end

    -- Nuke Neovim's existing highlights
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
      vim.cmd("syntax reset")
    end
    vim.g.colors_name = nil

    local ok_cat, cat = pcall(require, "catppuccin")
    if ok_cat then
      cat.setup({
        flavour = "mocha",
        compile = { enabled = false }, -- MUST be false for dynamic overrides
        color_overrides = overrides,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          bufferline = true,
          telescope = { enabled = true },
          indent_blankline = { enabled = true },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      })
      vim.cmd("colorscheme catppuccin")
    end

    -- Reload lualine dynamically safely
    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine then
      lualine.setup { options = { theme = 'catppuccin' } }
    end

    -- Force Neovim to redraw
    vim.cmd("redraw!")

    -- Provide visual confirmation
    vim.notify("Matugen colors reloaded!", vim.log.levels.INFO)
  end)
end

-- Initialize the colors immediately on startup
_G.reload_matugen_colors()

-- ==========================================================================
-- PLUGIN CONFIGURATIONS (Wrapped in pcall to prevent hard crashes)
-- ==========================================================================
local ok_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  ts_configs.setup {
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
  }
end

local ok_ibl, ibl = pcall(require, "ibl")
if ok_ibl then ibl.setup() end

local ok_git, gitsigns = pcall(require, 'gitsigns')
if ok_git then gitsigns.setup() end

local ok_pairs, autopairs = pcall(require, 'nvim-autopairs')
if ok_pairs then autopairs.setup({}) end

local ok_com, comment = pcall(require, 'Comment')
if ok_com then comment.setup() end

local ok_wk, whichkey = pcall(require, 'which-key')
if ok_wk then whichkey.setup() end


local ok_telescope, telescope = pcall(require, 'telescope')
if ok_telescope then
  telescope.setup {
    extensions = {
      ["ui-select"] = { require("telescope.themes").get_dropdown {} }
    }
  }
  pcall(telescope.load_extension, 'ui-select')

  local ok_builtin, builtin = pcall(require, 'telescope.builtin')
  if ok_builtin then
    vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader><leader>', builtin.oldfiles, { desc = 'Recent Files' })
  end
end

local ok_bufferline, bufferline = pcall(require, "bufferline")
if ok_bufferline then
  bufferline.setup{
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",
      separator_style = "slant",
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "left",
          separator = true
        }
      },
    }
  }
end
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
vim.keymap.set("n", "<leader>x", function()
  if vim.bo.filetype == "neo-tree" then return end
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd("BufferLineCycleNext")
  if vim.api.nvim_get_current_buf() ~= buf then
    vim.cmd("bdelete " .. buf)
  else
    -- Last buffer: open empty buffer so Neo-tree doesn't fill the window
    vim.cmd("enew")
    vim.cmd("bdelete " .. buf)
  end
end, { silent = true, desc = "Close Buffer" })

local ok_cmp, cmp = pcall(require, 'cmp')
local ok_luasnip, luasnip = pcall(require, 'luasnip')
if ok_cmp and ok_luasnip then
  pcall(function() require("luasnip.loaders.from_vscode").lazy_load() end)

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          cmp.confirm({ select = false })
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    },
  }
end

-- ==========================================================================
-- MASON (LSP/TOOL INSTALLER)
-- ==========================================================================
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
  mason.setup()
end

local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
if ok_mlsp then
  mason_lspconfig.setup({
    ensure_installed = { "pyright", "lua_ls", "html" },
    automatic_installation = true,
  })
end

-- ==========================================================================
-- LSP SETUP
-- ==========================================================================
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

vim.lsp.config('pyright', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = { formatting = { provider = "none" } },
  },
})
vim.lsp.config('nil_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.config('html', {
  capabilities = capabilities,
  on_attach = on_attach,
})
vim.lsp.enable({ 'pyright', 'nil_ls', 'lua_ls', 'html' })

-- ==========================================================================
-- DIAGNOSTICS
-- ==========================================================================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- ==========================================================================
-- NONE-LS (FORMATTING & LINTING)
-- ==========================================================================
local ok_nls, null_ls = pcall(require, 'null-ls')
if ok_nls then
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.black,
      null_ls.builtins.diagnostics.mypy.with({
        extra_args = function()
          local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
          return { "--python-executable", virtual .. "/bin/python3" }
        end,
      }),
    },
  })
  vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format File" })
end

-- Format Python on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- ==========================================================================
-- KEYMAPS
-- ==========================================================================
-- Window navigation
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { silent = true })

-- Visual mode: move selected lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Paste over selection without replacing register
vim.keymap.set('v', '<leader>p', '"_dPV')

-- Insert mode: exit with jk
vim.keymap.set('i', 'jk', '<Esc>')

-- Clear search highlight
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { silent = true })

-- Netrw vertical split (quick file browse)
vim.keymap.set('n', '<leader>pv', ':Vex<CR>')

-- Source this config
vim.keymap.set('n', '<leader><CR>', ':so ~/.config/nvim/init.lua<CR>')

-- ==========================================================================
-- ASYNC DIRECTORY WATCHER FOR DYNAMIC RELOADING
-- ==========================================================================
local uv = vim.uv or vim.loop
local config_dir = vim.fn.stdpath("config")
local reload_timer = uv.new_timer()

local watcher = uv.new_fs_event()
if watcher then
  -- We watch the entire config directory to avoid inode replacement breaking the watcher
  watcher:start(config_dir, {}, vim.schedule_wrap(function(err, filename, events)
    if not err and filename == "matugen_colors.lua" then

      -- Debounce the events to catch both Matugen's write and our sed modification
      reload_timer:stop()
      reload_timer:start(250, 0, vim.schedule_wrap(function()
        _G.reload_matugen_colors()
      end))

    end
  end))
end
