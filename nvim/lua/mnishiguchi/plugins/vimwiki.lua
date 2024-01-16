-- https://github.com/vimwiki/vimwiki/tree/dev
return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      {
        path   = '~/Documents/vimwiki/',
        syntax = 'markdown',
        ext    = '.md',
      }
    }

    -- restrict Vimwiki's operation to only those paths listed in g:vimwiki_list
    vim.g.vimwiki_global_ext = 0
  end,
}
