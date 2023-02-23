""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
" See https://github.com/VundleVim/Vundle.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'ap/vim-css-color'
Plugin 'elixir-editors/vim-elixir'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf'
Plugin 'pangloss/vim-javascript'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-ruby/vim-ruby'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" theme
syntax enable
colorscheme molokai

" line numbers
set number relativenumber

" cursor line
set cursorline
set cursorcolumn
set colorcolumn=80
set scrolloff=8
set signcolumn=yes

" tabs
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2

" indent
set autoindent
set smartindent

" diffs
set diffopt=filler,vertical " side by side

" command completion
set path+=**
set wildmenu
set wildmode=full

" word wrap
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing

" search highlight
set nohlsearch
set incsearch

" others
set termguicolors " highlight groups
set isfname+=@-@ " all alphas

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
nnoremap <Leader>pv :Explore<CR>

" search files with fzf
nnoremap <Leader>pf :Files<CR>

" make tags for tag-jumping
nnoremap <Leader>ct :!ctags -R .<CR>
nnoremap t  <Nop>
nnoremap tt <C-]>

" keep the cursor centered while moving up and down
nnoremap j jzz
nnoremap k kzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" keep the cursor centered while searching
nnoremap n nzzzv
nnoremap N Nzzzv

" check marks and registers easily
nnoremap <Leader>m :<C-u>marks<CR>
nnoremap <Leader>r :<C-u>registers<CR>
nnoremap <Leader>t :<C-u>tags<CR>

" close buffers
nnoremap <Leader>q :bdelete!<CR>

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

  " set some file types
  autocmd BufRead,BufNewFile mix.lock set filetype=elixir
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} set filetype=ruby
augroup END
