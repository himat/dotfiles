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

" Indent as intelligently as vim knows how
"set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" JS files should only indent by 2 spaces
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2

" Set files with matching names to be highlighted as shell script files
autocmd BufEnter,BufNewFile,BufRead *aliasrc,*shellrc* set syntax=sh

" Show multicharacter commands as they are being typed
set showcmd

"set incsearch "Moves cursor to matched string while typing
"set hlsearch "Highlights all search matches
set ignorecase "Search ignoring case
set smartcase "Search using smart casing

" For commands like buffer switching and page up/down, vim moves the cursor to
"   the start of line by default. This is not useful when moving somewhere and
"   then coming back since your old cursor position is now gone. This fixes
"   that.
set nostartofline

"Changes vim's internal dir to that of current file's
"set autochdir " Disabled since it was interfering with my autosaving sessions

" set mouse=a
set mouse=n
" set ttymouse=xterm

" Press enter twice to insert a newline below without going into insert mode
nnoremap <CR><CR> o<ESC>

" leader shift-P to insert a pdb line
au FileType python nnoremap <leader><S-p> oimport pdb; pdb.set_trace()<Esc>
" leader shift-I to insert an interactive prompt in the script
au FileType python nnoremap <leader><S-i> oimport IPython; IPython.embed(); import sys; sys.exit(0)<Esc>

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

" Shows a horizontal menu of file names that provide tab completion
set wildmenu
set wildmode=full
set wildignorecase

" Keybinding for toggling paste mode
set pastetoggle=<F2>

"" Buffer bindings
" Press F5 to show all open files and type the number to switch to
nnoremap <F5> :buffers<CR>:buffer<Space>
" Close current buffer by switching to previous buff (so that the current
" split doesn't get closed which is what happens when you use just :bd)
nnoremap <silent> <leader>d :bp\|bd #<CR>
" H and L for prev and next buffers
nnoremap H :bp<CR>
nnoremap L :bn<CR>
" List all buffers and just enter the number you want to easily switch to it
"nnoremap <leader>b :ls<CR>:b<Space>
" Switch to previously used buffer
nnoremap <leader><leader>b :b#<CR>

"" Vim tab bindings
nnoremap gc :tabnew<CR>
" Better left and right tab switching
nnoremap gh gT
nnoremap gl gt
" Switch to previously used tab
if !exists('g:lasttab') " Handles if last tab is gone
  let g:lasttab = 1
endif
nnoremap <leader><leader>g :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" Easier numbered tab switching
noremap <leader>1g 1gt
noremap <leader>2g 2gt
noremap <leader>3g 3gt
noremap <leader>4g 4gt
noremap <leader>5g 5gt
noremap <leader>6g 6gt
noremap <leader>7g 7gt
noremap <leader>8g 8gt
noremap <leader>9g 9gt
" rightmost tab
noremap <leader>0g :tablast<CR>

" Alternate easier numbered tab switching
noremap g1 1gt
noremap g2 2gt
noremap g3 3gt
noremap g4 4gt
noremap g5 5gt
noremap g6 6gt
noremap g7 7gt
noremap g8 8gt
noremap g9 9gt
noremap g0 :tablast<CR>

" Change position of new splits to open below and to the right by default
set splitbelow
set splitright

" Resize split panes by more sane amounts than just the default 1 row/col
nnoremap <C-w>- :exe "resize " . (winheight(0) * 5/6)<CR>
nnoremap <C-w>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <C-w>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nnoremap <C-w>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>

" Removes trailing whitespace from all lines in file
function! TrimTrailingWhitespace()
    let l:save = winsaveview() " Save window cursor info to restore
    " keeppatterns executes command without adding to history
    " 'e' doesn't err on if match not found
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
noremap <Leader>tr :call TrimTrailingWhitespace()<CR>

" Sessions
" Do not store options (overrides vimrc updates)
set ssop-=options
" Set session file to not save/restore empty windows in vim (had to do this 
" because nerdtree plugin would always give me errors when reopening a session 
" since nerdtree does not actually save the tree to disk so they are seen as 
" blank windows, so it doesn't work with vim sessions)
set sessionoptions-=blank

" Make a session from the current vim layout
nnoremap <leader>ms :call MakeSession()<cr>

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
function! DeleteSession()
    let b:sessiondir = $HOME . "/.vim_sessions" . getcwd()
    if (filewritable(b:sessiondir) == 2) " 2: is a writable dir
        exe 'silent !rm -r ' b:sessiondir
        redraw!
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
" Plugins settings below

" set the runtime path to include Vundle and initialize
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'christoomey/vim-tmux-navigator'

" Themes
Plugin 'altercation/vim-colors-solarized'
Plugin 'mhartington/oceanic-next'
"Plugin 'tyrannicaltoucan/vim-deep-space'
"Plugin 'YorickPeterse/happy_hacking.vim'

Plugin 'scrooloose/nerdTree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'

Plugin 'haya14busa/incsearch.vim' " Better jump to search as you type

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'scrooloose/syntastic'

Plugin 'tmhedberg/SimpylFold' " Python folding
Plugin 'JavaScript-Indent' " JS/html better indenting

""Plugin 'Valloric/YouCompleteMe'

"Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ludovicchabant/vim-gutentags'
"Plugin 'majutsushi/tagbar' " Shows a side panel of the current file's tags (class/methods)

Plugin 'alvan/vim-closetag' " Auto closes HTML tags
Plugin 'jiangmiao/auto-pairs' " Auto completing brackets

"Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets'

Plugin 'tpope/vim-surround' " Easily enclose text in parens and tags
Plugin 'tpope/vim-abolish' " Do substitutions while prserving the case of words
Plugin 'chaoren/vim-wordmotion'


" Autocomplete. Uses YCM as its base
Plugin 'zxqfl/tabnine-vim'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Language/framework tools
Plugin 'jparise/vim-graphql' " Graphql syntax highlighting and indentation

call vundle#end()

"Enable filetype detection and syntax highlighting
"Must put after vundle block so that plugins can detect their own filetypes
syntax enable
filetype on
filetype indent on
filetype plugin on

set t_Co=256

" ----------------- PLUGIN SETTINGS START HERE -----------------

"set background=dark
"set termguicolors
"colorscheme deep-space

"set background=dark
"colorscheme solarized

let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

"colorscheme happy_hacking

" set background=dark
" colorscheme base16-twilight
" let base16colorspace=256

if g:colors_name == 'OceanicNext'
    " Make folded text fg whiter
    hi Folded ctermfg=248
endif

"hi Normal ctermbg=NONE "Need this so text doesn't have bg

""" UltiSnips -----------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" TODO: Doesn't work for some reason
let g:UltiSnipsExpandTrigger="<c-y>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


""" YCM ----------------------------------
" Set shift tab to tab backwards (to the left)
"inoremap <S-Tab> <C-d> " Would use this normally when YCM is not installed
" Removes <S-Tab> from the default key list
let g:ycm_key_list_previous_completion = ['<Up>'] 
" Redefine so that in insert mode if the YCM list is visible, 
" it scrolls up, otherwise, it unindents 
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-d>" 


" Vim closetag ----------------------------
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.ts'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

""" vim airline -----------------------------
set laststatus=2 " Always show status bar

" Auto find powerline symbols to display airline bar properly
let g:airline_powerline_fonts = 1

let g:airline_theme='cobalt2'

" Defining a patch function lets us override pieces of an existing theme
" Look at ~/.vim/bundle/vim-airline-themes/autoload/airline/themes to see what
"   each color scheme has defined. Look at the dark vim color file for basics.
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    if g:airline_theme == 'cobalt2'
      let a:palette['tabline']['airline_tabsel'] = ['#ffffff', '#46dd3c', 0, 11, '']
    endif
endfunction

"let g:airline_left_sep='>'
" let g:airline_right_sep='<'
"
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " Show tab numbers
let g:airline#extensions#whitespace#enabled = 0 " Don't show trailing whitespace warnings

" makes the display update faster when switching out of insert mode
set ttimeoutlen=50

""" NERDTREE TABS -----------------------------
map <C-n> :NERDTreeToggle<CR>
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" have NERDTree always open on startup
" let g:nerdtree_tabs_open_on_console_startup = 1
" Close current tab if there is only one window in it and it's NERDTree (default 1)
let g:nerdtree_tabs_autoclose=0
" Open dir/file with space
let NERDTreeMapActivateNode='<space>'

" NERDCOMMENTER settings
" nmap <silent> <leader>
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1

" INCSEARCH settings -----------------------------
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)

" fzf settings --------------------------
" Using the same key as for ctrl-P plugin since I'm used to that
map <C-p> :Files<CR>

" Open fzf buffers pane
nnoremap <leader>b :Buffers<CR>
" Open fzf file history pane
nnoremap <leader>h :History<CR>
" Open fzf executed command history pane
nnoremap <leader>c :History:<CR>
" Open fzf command list pane
nnoremap <leader>C :Commands<CR>
" Open fzf marks pane
nnoremap <leader>m :Marks<CR>

" ctrlp settings -----------------------------
" Auto-exclude files from being indexed in the current dir if they are
"   excluded from git. This will make CtrlP much faster for when you have
"   large data/ directories in a project.
" TODO: Problem with this is that if a file is deleted in the dir, but it was
"   commited in git before, then the file will still appear in the CtrlP list
"   So should also call 'find' and then perform an intersection of the two
"   commands' outputs using 'comm'. Will need to write this as a separate
"   function since can't do this in one line nicely.
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
" Need these two for very large projects
"let g:ctrlp_max_files=0
"let g:ctrlp_max_depth=40


" Search for tags (globally) with ctrlp
"nnoremap <leader>. :CtrlPTag<cr>
" Search for tags (in current buffer) with ctrlp
"nnoremap <leader>> :CtrlPBufTag<cr>

" SYNTASTIC settings -----------------------------
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

" Syntastic {
    let g:syntastic_enable_signs=1
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_javascript_checkers=['eslint']
    let g:syntastic_python_flake8_args = "--max-line-length=120"
    " let g:syntastic_python_pylint_args = '-E'
    let g:syntastic_cpp_include_dirs = ['source', 'build/source', '/usr/include']
    let g:syntastic_cpp_compiler = 'clang++-3.5'
    let g:syntastic_cpp_compiler_options = ' -std=c++11'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0
    " let g:syntastic_debug = 1
" }

" Gutentags settings --------------------------
set statusline+=%{gutentags#statusline()} " Prints when Gutentags is generating tags in the background


" Tagbar settings -----------------------------
" Main benefit of tagbar for me is that with airline, it auto-shows the
"   current tag (class/method/etc) that my cursor is currently in 
"   on the airline status bar

" Opens the tagbar side pane, and auto-closes it once you go to a tag
nmap <leader>g :TagbarOpenAutoClose<CR> 

" ----------------- PLUGIN SETTINGS END HERE -----------------


""" Cursor settings
" (needed to put after plugins since something was interfering with the colors)
set cursorline "Highlight current line
set colorcolumn=80 "Highlight 80 char col
"Highlight current line number
highlight CursorLineNR cterm=bold ctermfg=black ctermbg=green guifg=black guibg=green

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " from: https://sunaku.github.io/vim-256color-bce.html
  set t_ut=
endif

