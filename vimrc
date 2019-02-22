" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start
filetype off " required for Vundle plugin manager

" highlight occurrences from searches
set hlsearch

" clears highlighting till next search
" ctrl L - it also normally redraws the vim screen
" NOTE: broken because of vim tmux navigator using C-l
nnoremap <C-L> :noh<CR><C-L>

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
" maps escape key back bc vim uses it for special keys internally
nnoremap <esc>^[ <esc>^[ 

" Set shift tab to tab backwards (to the left)
inoremap <S-Tab> <C-d>

" Set Y to copy to end of line like C and D do
nmap Y y$

" Cold folding on
set foldmethod=indent
" Enable fold toggling with the spacebar
nnoremap <space> za 
vnoremap <space> za 

" Helpful information: cursor position in bottom right, line numbers on
" left
set ruler
set number

"Enable filetype detection and syntax highlighting 
syntax on
filetype on
filetype indent on
filetype plugin on

" Indent as intelligently as vim knows how
"set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Show multicharacter commands as they are being typed
set showcmd

"set incsearch "Moves cursor to matched string while typing
"set hlsearch "Highlights all search matches
set ignorecase "Search ignoring case
set smartcase "Search using smart casing


"Changes vim's internal dir to that of current file's
"set autochdir " Disabled since it was interfering with my autosaving sessions

" set mouse=a
set mouse=n
" set ttymouse=xterm

" leader shift-P to insert a pdb line
nnoremap <leader><S-p> oimport pdb; pdb.set_trace()<Esc>
" leader shift-I to insert an interactive prompt in the script
nnoremap <leader><S-i> oimport IPython; IPython.embed(); import sys; sys.exit(0)<Esc>

" In visual mode, you can paste over something without the deleted text 
"   overwriting the text in the unnamed register. So now you can easily past 
"   a yanked text multiple places just using the default unnamed register.
"   The deleted text here goes to the black hole register "_
vnoremap p "_dp
vnoremap P "_dP

" Synchronizes vim's default register and the system clipboard so you can just
" use y and p to copy and paste the same text anywhere on your computer 
"set clipboard^=unnamed
"set clipboard=unnamed

" Buffers for switching between files
" Press F5 to show all open files and type the number to switch to
nnoremap <F5> :buffers<CR>:buffer<Space>
" Close current buffer by switching to previous buff (so that the current
" split doesn't get closed which is what happens when you use just :bd)
nnoremap <silent> <leader>d :bp\|bd #<CR>
" H and L for prev and next buffers
nnoremap H :bp<CR>
nnoremap L :bn<CR>
" List all buffers and just enter the number you want to easily switch to it
nnoremap <leader>b :ls<CR>:b<Space>
" Switch to previously used buffer
nnoremap <leader><leader>b :b#<CR>

" Change position of new splits to open below and to the right by default
set splitbelow
set splitright

" Resize split panes by more sane amounts than just the default 1 row/col
nnoremap <C-w>- :exe "resize " . (winheight(0) * 5/6)<CR>
nnoremap <C-w>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <C-w>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nnoremap <C-w>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>

" Sessions 
" Do not store options (overrides vimrc updates)
set ssop-=options  
nnoremap <leader>ms :call MakeSession()<cr>
" If you omit 'options' from 'sessionoptions', you might want to use nested 
" flag from VimEnter autocmd. Syntax highlighting and mappings 
" might not be restored otherwise. Enable this if you see this problem
" autocmd VimEnter * nested call RestoreSession()  

"" Make and load method to save session per dir
function! MakeSession()
    let b:sessiondir = $HOME . "/.vim_sessions" . getcwd()
    if (filewritable(b:sessiondir) != 2)
        exe 'silent !mkdir -p ' b:sessiondir
        redraw!
    endif
    let b:sessionfile = b:sessiondir . "/session.vim"
    exe "mksession! " . b:sessionfile
endfunction
function! UpdateSession() " Only saves session if it already exists
    let b:sessiondir = $HOME . "/.vim_sessions" . getcwd()
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
        exe "mksession! " . b:sessionfile
        echo "Updating session"
    endif
endfunction
function! LoadSession()
    let b:sessiondir = $HOME . "/.vim_sessions" . getcwd()
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
        exe 'source ' b:sessionfile
    else
        echo "No session loaded."
    endif
endfunction

" Auto-commands 
augroup autosourcing
    if(argc() == 0) " Only run if vim started in dir with no args
        au VimEnter * nested :call LoadSession() " Automatically load session
        au VimLeave * :call UpdateSession() " Auto saves session if exists 
    endif
augroup END


" =============================================================================
" =============================================================================
" =============================================================================
" =============================================================================
" Plugin settings below

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'kristijanhusak/vim-hybrid-material'

" vim-c0 plugin on Github repo
" Plugin 'cmugpi/vim-c0'
Plugin 'christoomey/vim-tmux-navigator'

Plugin 'altercation/vim-colors-solarized'

Plugin 'scrooloose/nerdTree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'

Plugin 'haya14busa/incsearch.vim' " Better jump to search as you type

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'scrooloose/syntastic'

Plugin 'tmhedberg/SimpylFold' " Python folding

"Plugin 'Valloric/YouCompleteMe'
Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'chaoren/vim-wordmotion'
call vundle#end()


" ----------------- PLUGIN SETTINGS START HERE -----------------

syntax enable
set background=dark
set t_Co=256
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

let g:airline_theme='badwolf'

let g:airline_left_sep='>'
" let g:airline_right_sep='<'
"
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled = 1

" makes the display update faster when switching out of insert mode
set ttimeoutlen=50

" NERDTREE TABS SETTINGS
map <C-n> :NERDTreeToggle<CR>
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" have NERDTree always open on startup
" let g:nerdtree_tabs_open_on_console_startup = 1
" Close current tab if there is only one window in it and it's NERDTree (default 1)
let g:nerdtree_tabs_autoclose=0
" Open dir/file with space
let NERDTreeMapActivateNode='<space>'

" NERDCOMMENTER SETTINGS 
" nmap <silent> <leader>
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1

" INCSEARCH SETTINGS 
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)

" ctrlp settings
" Need these two for very large projects
"let g:ctrlp_max_files=0
"let g:ctrlp_max_depth=40

" SYNTASTIC SETTINGS 
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

" let g:syntastic_auto_loc_list = 1
" let g:syntastic_debug = 1 

"let g:syntastic_python_pylint_args = '-E'

" Syntastic {
    let g:syntastic_enable_signs=1
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_python_flake8_args = "--max-line-length=120"
    let g:syntastic_cpp_include_dirs = ['source', 'build/source', '/usr/include']
    let g:syntastic_cpp_compiler = 'clang++-3.5'
    let g:syntastic_cpp_compiler_options = ' -std=c++11'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0
" }

" Cursor settings
set cursorline "Highlight current line
set colorcolumn=80 "Highlight 80 char col 
"Highlight current line number
highlight CursorLineNR cterm=bold ctermfg=black ctermbg=green guifg=black guibg=green 


