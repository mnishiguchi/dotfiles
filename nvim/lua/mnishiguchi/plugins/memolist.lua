-- https://github.com/glidenote/memolist.vim
return {
  "glidenote/memolist.vim",
  init = function()
    vim.g.memolist_path              = "$HOME/Documents/memo"
    vim.g.memolist_memo_suffix       = "md"
    vim.g.memolist_template_dir_path = "$HOME/Documents/templates"
  end,
}
