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
Jetpack 'junegunn/fzf.vim'
Jetpack 'junegunn/fzf', { 'do': {-> fzf#install()} }
Jetpack 'pangloss/vim-javascript'
Jetpack 'tomasr/molokai'
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
Jetpack 'vim-airline/vim-airline-themes'
Jetpack 'vim-airline/vim-airline'
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

" disable <leader>p to avoid unexpected pasting
nnoremap <Leader>p <Nop>

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

  " open quick fix window on grep
  autocmd QuickFixCmdPost *grep* cwindow

  " set some file types
  autocmd BufRead,BufNewFile mix.lock set filetype=elixir
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} set filetype=ruby
augroup END
