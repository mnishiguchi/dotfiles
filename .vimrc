execute pathogen#infect()

set nocompatible
filetype plugin on

" Finding files

set path+=**  " search subfolders
set wildmenu  " show all patching files on tab completion

" Indenting

set shiftwidth=2
set autoindent
set smartindent

" Spaces & Tabs

set expandtab      " tabs are spaces
set tabstop=2      " number of visual spaces per TAB
set softtabstop=2  " number of spaces in tab when editing
set smarttab

" UI

syntax on       " stntax highlighting
set number      " show line numbers
set cursorline  " highlight current line
set showmatch   " highlight matching [{()}]
