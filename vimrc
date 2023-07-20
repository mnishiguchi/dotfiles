""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
" See https://github.com/tani/vim-jetpack
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd vim-jetpack

call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1}

Jetpack 'airblade/vim-gitgutter'
Jetpack 'ap/vim-css-color'
Jetpack 'elixir-editors/vim-elixir'
Jetpack 'junegunn/fzf', { 'do': {-> fzf#install()} }
Jetpack 'junegunn/fzf.vim'
Jetpack 'mhinz/vim-startify'
Jetpack 'pangloss/vim-javascript'
Jetpack 'sbdchd/neoformat',
Jetpack 'tomasr/molokai'
Jetpack 'tpope/vim-abolish'
Jetpack 'tpope/vim-commentary'
Jetpack 'tpope/vim-endwise'
Jetpack 'tpope/vim-eunuch'
Jetpack 'tpope/vim-fugitive'
Jetpack 'tpope/vim-rails'
Jetpack 'tpope/vim-repeat'
Jetpack 'tpope/vim-rhubarb'
Jetpack 'tpope/vim-sleuth'
Jetpack 'tpope/vim-surround'
Jetpack 'tpope/vim-unimpaired'
Jetpack 'vim-airline/vim-airline'
Jetpack 'vim-airline/vim-airline-themes'
Jetpack 'vim-ruby/vim-ruby'
call jetpack#end()

" ## Commands
"
" * `:JetpackSync`
"   * install, update, and bundle all plugins
"   * must be run after a change of your configuration
"
" * `:Jetpack repo [, options]`
"   * a command version of `jetpack#add()`
"   * useful for the vim-plug style declaration of plugins in vimrc
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" theme
syntax enable
colorscheme molokai

" line numbers
set number relativenumber

" tabs
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2

" indent
set autoindent
set smartindent

" line wrapping
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing

" search
set ignorecase
set smartcase
set nohlsearch
set incsearch

" appearance
set termguicolors " highlight groups
set cursorline
set cursorcolumn
set colorcolumn=80
set scrolloff=8
set signcolumn=yes
let g:netrw_banner=0

" diffs
set diffopt=filler,vertical " side by side

" command completion
set path+=**
set wildmenu
set wildmode=full

" backup
set nobackup noswapfile nowritebackup

" others
set isfname+=@-@ " all alphas
set iskeyword+=- "make "-" part of word

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use space as mapleader
map <Space> <Leader>
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

" edit vimrc quickly
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Leader>s. :<C-u>source $MYVIMRC<CR>

" show the file explore
nnoremap <Leader>e :Explore<CR>

" search files with fzf
nnoremap <Leader>ff :Files<CR>

" make tags for tag-jumping
nnoremap <Leader>ct :!ctags -R .<CR>
nnoremap t  <Nop>
nnoremap tt <C-]>

" keep the cursor centered while moving up and down
nnoremap j jzz
nnoremap k kzz
nnoremap { {zz
nnoremap } }zz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <Up> <Up>zz
nnoremap <Down> <Down>zz

" keep the cursor centered while searching
nnoremap n nzzzv
nnoremap N Nzzzv

" check marks and registers easily
nnoremap <Leader>fm :<C-u>marks<CR>
nnoremap <Leader>fr :<C-u>registers<CR>
nnoremap <Leader>ft :<C-u>tags<CR>

" close buffers
nnoremap <Leader>q :bdelete!<CR>

" Copy the link to the line of a Git repository to the clipboard
nnoremap <leader>v :.GBrowse!<CR>
xnoremap <leader>v :GBrowse!<CR>

" Press jk fast to exit insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" bind :Q to :q
command! Q q
command! QA qall
command! Qa qall
command! W w
command! WQ wq
command! Wq wq
command! E e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup random
  autocmd!

  " strip trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e

  " open quick fix window on grep
  autocmd QuickFixCmdPost *grep* cwindow

  " set some file types
  autocmd BufRead,BufNewFile mix.lock set filetype=elixir
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} set filetype=ruby
augroup END
