-- nvim-treesitter `main` branch API:
--   * parsers are installed via require('nvim-treesitter').install({...})
--   * highlighting/indent are started per-buffer via vim.treesitter.*
--   * no more configs.setup{} module-style config
local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then return end

local parsers = { 'javascript', 'typescript', 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' }

local installed = {}
for _, p in ipairs(ts.get_installed() or {}) do installed[p] = true end
local missing = {}
for _, p in ipairs(parsers) do
  if not installed[p] then table.insert(missing, p) end
end
if #missing > 0 then ts.install(missing) end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('jh3_treesitter', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and pcall(vim.treesitter.start, args.buf, lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
