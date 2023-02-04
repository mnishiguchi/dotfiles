" ## basic setup
"
syntax enable
filetype plugin on

" ## line numbers
"
set number
set relativenumber
set laststatus=2

" ## indent
"
set autoindent
set smartindent

" ## tabs
"
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" ## finding files
"
" - :find - find a file by substring
" - * - make it fuzzy
" - :ls - list all open files
" - :b - fuzzy search files in the buffer
"
set path+=**
set wildmenu

" ## tag-jumping using ctags program
"
" - ^] - jump to the tag under cursor
" - g^] - for ambiguous tags
" - ^t - jump back up the tag stack
"
command! MakeTags !ctags -R .

" ## keep cursor centered
"
:nnoremap j jzz
:nnoremap k kzz
:nnoremap n nzzzv
:nnoremap N Nzzzv
:nnoremap <C-d> <C-d>zz
:nnoremap <C-u> <C-u>zz

" ## etc
"
set diffopt+=vertical " show diffs side by side
