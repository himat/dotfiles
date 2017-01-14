
" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start
filetype off " required for Vundle plugin manager

" clears highlighting till next search
" ctrl L - it also normally redraws the vim screen
" NOTE: broken because of vim tmux navigator using C-l
nnoremap <C-L> :noh<CR><C-L>

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
" maps escape key back bc vim uses it for special keys internally
nnoremap <esc>^[ <esc>^[ 

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'kristijanhusak/vim-hybrid-material'

" vim-c0 plugin on Github repo
" Plugin 'cmugpi/vim-c0'
Plugin 'christoomey/vim-tmux-navigator'

Plugin 'altercation/vim-colors-solarized'

Plugin 'scrooloose/nerdTree'
" Plugin 'jistr/vim-nerdtree-tabs'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'scrooloose/syntastic'

Plugin 'jez/vim-better-sml'
call vundle#end()

" Helpful information: cursor position in bottom right, line numbers on
" left
set ruler
set number

"Enable filetype detection and syntax hilighting
syntax on
filetype on
filetype indent on
filetype plugin on

" Indent as intelligently as vim knows how
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Show multicharacter commands as they are being typed
set showcmd

set ignorecase "Search ignoring case
set smartcase "Search using smart casing

" Random things
set cursorline "Highlight current line
set colorcolumn=80 "Highlight 80 char col 
set autochdir "Changes vim's internal dir to that of current file's

set mouse=a
" set mouse=n
" set ttymouse=xterm

" Synchronizes vim's default register and the system clipboard so you can just
" use y and p to copy and paste the same text anywhere on your computer 
set clipboard^=unnamed

" ----------------- PLUGIN SETTINGS START HERE -----------------

syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_contrast="high"
colorscheme solarized


"hi Normal ctermbg=NONE "Need this so text doesn't have bg


" base 16 theme
" syntax enable
"set background=dark
" colorscheme base16-twilight
" let base16colorspace=256

" vim airline
set laststatus=2
set t_Co=256

let g:airline_theme='badwolf'

let g:airline_left_sep='>'
" let g:airline_right_sep='<'
"
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled = 1

" makes the display update faster when switching out of insert mode
set ttimeoutlen=50

" nerdtree tabs
" Open/close NERDTree Tabs with \t
" nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" have NERDTree always open on startup
" let g:nerdtree_tabs_open_on_console_startup = 1

" syntastic settings
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
    au!
    au FileType tex let b:syntastic_mode = "passive"
    
    " tell syntastic to always stick any detected errors into the
    " location-list
    au FileType sml let g:syntastic_always_populate_loc_list = 1
    "auto open and/or close the lcation-list
    au FileType sml let g:syntastic_auto_loc_list = 1
augroup END

" press <Leader>S (i.e., \S) to not automatically check for errors
nnoremap <Leader>S :SyntasticToggleMode<CR>

" type :lclose to close vim's loation list -- useful


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" let g:syntastic_debug = 1 
