
-- ============================================================
-- NEOVIM - CONFIGURACION PRINCIPAL
-- Windows + LaTeX + VimTeX + SumatraPDF
-- ============================================================

-- Desactivar netrw para utilizar nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================================================
-- GESTOR DE COMPLEMENTOS: lazy.nvim
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ==========================================================
  -- VIMTEX: EDICION DE LATEX
  -- ==========================================================

  {
    "lervag/vimtex",
    tag = "v2.17",
    lazy = false,

    init = function()
      vim.g.vimtex_view_method = "general"

      vim.g.vimtex_view_general_viewer =
        "C:/Users/moran/AppData/Local/SumatraPDF/SumatraPDF.exe"

      vim.g.vimtex_view_general_options =
        "-reuse-instance -forward-search @tex @line @pdf"

      vim.g.vimtex_compiler_method = "latexmk"

      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},

        options = {
          "-xelatex",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
  },

  -- ==========================================================
  -- NVIM-TREE: EXPLORADOR LATERAL
  -- ==========================================================

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      view = {
        width = 25,
      },

      renderer = {
        indent_markers = {
          enable = true,
        },
      },

      filesystem_watchers = {
        enable = false,
      },
    },
  },

  -- ==========================================================
  -- SCROLLVIEW: BARRAS DE DESPLAZAMIENTO
  -- ==========================================================

  {
    "dstein64/nvim-scrollview",
    lazy = false,

    opts = {
      current_only = false,
    },
  },

})

-- ============================================================
-- CARPETA DE TRABAJO PREDETERMINADA
-- ============================================================

vim.api.nvim_set_current_dir("F:/LATEX/neovim")

-- ============================================================
-- ABRIR AUTOMATICAMENTE EL EXPLORADOR NVIM-TREE
-- ============================================================

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      api.tree.open()
    end
  end,
})

-- ============================================================
-- TEMA DE COLORES
-- ============================================================

vim.cmd.colorscheme("unokai")

-- ============================================================
-- BARRA INFERIOR SEGUN EL MODO
-- ============================================================

vim.opt.showmode = true
vim.opt.statusline = " %{mode()} %f %m %=%l:%c "

local colores_modo = {
  n = "#286B45", -- NORMAL: verde
  i = "#D00000", -- INSERT: rojo
  v = "#2463C5", -- VISUAL: azul
  V = "#2463C5",
}

local function actualizar_barra()
  local modo = vim.api.nvim_get_mode().mode:sub(1, 1)
  local fondo = colores_modo[modo] or "#505050"

  vim.api.nvim_set_hl(0, "StatusLine", {
    fg = "#FFFFFF",
    bg = fondo,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "StatusLineNC", {
    fg = "#FFFFFF",
    bg = "#505050",
  })
end

vim.api.nvim_create_autocmd({
  "ModeChanged",
  "VimEnter",
  "ColorScheme",
}, {
  callback = actualizar_barra,
})

actualizar_barra()

-- ============================================================
-- F5: SINCRONIZACION CON SUMATRAPDF
-- ============================================================

vim.keymap.set(
  "n",
  "<F5>",
  "<cmd>VimtexView<CR>",
  {
    desc = "Sincronizar Neovim con SumatraPDF",
    silent = true,
  }
)

-- Servidor para la sincronizacion inversa SumatraPDF -> Neovim
vim.fn.serverstart("\\\\.\\pipe\\nvim-sumatra")

-- ============================================================
-- AJUSTE DE LINEAS SIN CORTAR PALABRAS
-- ============================================================

vim.opt.wrap = true
vim.opt.linebreak = true

-- ============================================================
-- PORTAPAPELES DE WINDOWS
-- ============================================================

vim.opt.clipboard = "unnamedplus"

-- ============================================================
-- PROTECCION ANTE BLOQUEOS
-- ============================================================

vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = true

-- ============================================================
-- FACILITAR ESCRITURA DE COMANDOS
-- ============================================================

vim.keymap.set("c", ":", function()
  if vim.fn.getcmdtype() == ":" and
     vim.fn.getcmdpos() == 1 then
    return ""
  end

  return ":"
end, {
  expr = true,
})

-- ============================================================
-- FIN DE LA CONFIGURACION
-- ============================================================

