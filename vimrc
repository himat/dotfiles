" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

let mapleader=" "

" highlight occurrences from searches
set hlsearch

" -------------------- General settings below ------------------------

set t_Co=256

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
nnoremap <space><space> za
vnoremap <space><space> za

" Helpful information: cursor position in bottom right, line numbers on
" left
set ruler
set number

" Indent as intelligently as vim knows how
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

" Files that should only indent by 2 spaces
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
" autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType vue setlocal shiftwidth=2 tabstop=2

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
" nnoremap <CR><CR> o<ESC>

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
:nnoremap <leader>p :set invpaste<CR>

" Re-select the text you just pasted!
nnoremap gV `[v`]

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

" Map different keys for increment and decrement a number
nnoremap g+ <C-a>
nnoremap g- <C-x>

" Change position of new splits to open below and to the right by default
set splitbelow
set splitright

" Better sideways scrolling 
" You can just press 'z' once then h/l as you need. With normal vim, you need
" to keep pressing 'z' every time before h/l which is VERY slow.
nnoremap <silent> zh :call HorizontalScrollMode('h')<CR>
nnoremap <silent> zl :call HorizontalScrollMode('l')<CR>
nnoremap <silent> zH :call HorizontalScrollMode('H')<CR>
nnoremap <silent> zL :call HorizontalScrollMode('L')<CR>

function! HorizontalScrollMode( call_char )
    if &wrap
        return
    endif

    echohl Title
    let typed_char = a:call_char
    while index( [ 'h', 'l', 'H', 'L' ], typed_char ) != -1
        execute 'normal! z'.typed_char
        redraws
        echon '-- Horizontal scrolling mode (h/l/H/L)'
        let typed_char = nr2char(getchar())
    endwhile
    echohl None | echo '' | redraws
endfunction

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
" Plugins below -----

" Auto-install Plug if it's not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Themes
Plug 'altercation/vim-colors-solarized'
Plug 'mhartington/oceanic-next'
Plug 'NLKNguyen/papercolor-theme'
"Plug 'tyrannicaltoucan/vim-deep-space'
"Plug 'YorickPeterse/happy_hacking.vim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'lambdalisue/fern.vim' " File explorer pane
" Plug 'scrooloose/nerdTree' " Displays file explorer pane
" Plug 'jistr/vim-nerdtree-tabs'

Plug 'tomtom/tcomment_vim' " For code commenting

Plug 'haya14busa/incsearch.vim' " Better jump to search as you type
Plug 'haya14busa/incsearch-fuzzy.vim' " Fuzzy search as you type
Plug 'unblevable/quick-scope' " Highlights characters on current line when using seek motions

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plug 'scrooloose/syntastic'
" Plug 'dense-analysis/ale' " syntax checker and fixer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

""Plug 'Valloric/YouCompleteMe'

" Enable FastFold if you're having slowness with folds
" Plug 'Konfekt/FastFold' " NOTE: I haven't tried this plugin yet, just putting it here if it will be useful one day

"Plug 'ctrlpvim/ctrlp.vim'
" Plug 'ludovicchabant/vim-gutentags'
"Plug 'majutsushi/tagbar' " Shows a side panel of the current file's tags (class/methods)

Plug 'andymass/vim-matchup' " Extends the built-in % operator for more languages/words, also highlights words automatically
Plug 'alvan/vim-closetag' " Auto closes HTML tags
Plug 'jiangmiao/auto-pairs' " Auto completing brackets

" Use :IndentLinesToggle to toggle showing indents
Plug 'Yggdroot/indentLine' " Shows indentation levels 

" Shows surrounding code context for the line you're on
Plug 'wellle/context.vim'

"Plug 'SirVer/ultisnips'
Plug 'chamindra/marvim' " Save and run macros in a folder with custom names

Plug 'tpope/vim-fugitive' " Access git commands like blame inside vim
Plug 'tpope/vim-rhubarb' " GitHub extension for vim-fugitive
Plug 'airblade/vim-gitgutter' " Shows markers for lines changed/added/deleted in vim

Plug 'tpope/vim-surround' " Easily enclose text in parens and tags
Plug 'tpope/vim-abolish' " Do substitutions while preserving the case of words
Plug 'chaoren/vim-wordmotion'

" Autocomplete. Uses YCM as its base
" Plug 'zxqfl/tabnine-vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Language/framework tools
Plug 'tmhedberg/SimpylFold' " Python folding
Plug 'pangloss/vim-javascript' " JS syntax highlighting and improved indentation
Plug 'leafgarland/typescript-vim' " TS syntax highlighting
" Plug 'peitalin/vim-jsx-typescript' " tsx syntax highlighting
Plug 'jparise/vim-graphql' " Graphql syntax highlighting and indentation
Plug 'posva/vim-vue' " Vue syntax highlighting

call plug#end()

" ----------------- PLUGIN SETTINGS START HERE -----------------

" quick scope settings --------------------
" Triggers highlights only when pressing these keys instead of all the time
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" This changes the quick scope default colors (needed to do this since the
" default colors didn't appear with my light vim color scheme)
" NOTE: These lines need to happen before the 'colorscheme' is set in vim
augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#88b061' gui=underline ctermfg=129 cterm=bold,underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#49bfbf' gui=underline ctermfg=81 cterm=bold,underline
augroup END

"set background=dark
"set termguicolors
"colorscheme deep-space

"set background=dark
"colorscheme solarized

let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
" colorscheme OceanicNext


"colorscheme happy_hacking

set background=light
colorscheme PaperColor

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

""" Marvim macro saver/runner
" let g:marvim_store = '/usr/local/.marvim' " change store place.
let g:marvim_find_key = '<C-n>' " change find key from <F2> to 'space'
let g:marvim_store_key = 'macrosave'     " change store key from <F3> to 'ms'
" let g:marvim_register = 'q'       " change used register from 'q' to 'c' -
" you have to record macros in this register and then run the save command
" command Macrofind :call marvim#search()<CR>
" command Macrofind :call marvim#search()<CR>
" command Macrofind <C-n>
" command Macrostore :call marvim#macro_store()<CR>

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
" let g:closetag_close_shortcut = '<leader>>'

""" vim airline -----------------------------
set laststatus=2 " Always show status bar

" Auto find powerline symbols to display airline bar properly
let g:airline_powerline_fonts = 1

" let g:airline_theme='cobalt2'
let g:airline_theme='papercolor'

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

let g:airline#extensions#branch#enabled = 0 " Don't show git branch

" makes the display update faster when switching out of insert mode
set ttimeoutlen=50


""" Fern file explorer 
" Open/close with \t
nmap <silent> <leader>t :Fern . -reveal=%<CR>

" function! s:init_fern() abort
"   " remove default mappings we don't want 
"   unmap <buffer> h
"   unmap <buffer> l
"
"   " new mappings
"   nmap <buffer><expr> 
"       \ <Plug>(fern-my-expand-or-collapse)
"       \ fern#smart#leaf(
"       \   "\<Plug>(fern-action-collapse)",
"       \   "\<Plug>(fern-action-expand)",
"       \   "\<Plug>(fern-action-collapse)",
"       \ )
"   nmap <buffer><nowait><C-m> <Plug>(fern-my-expand-or-collapse) " Enter key expands/folds a folder
"
"   
"   nmap <buffer> o <Plug>(fern-action-open)
"   nmap <buffer> r <Plug>(fern-action-reload)
"   nmap <buffer> R <Plug>(fern-action-rename)
"
"   nmap <buffer> q :<C-u>quit<CR>
" endfunction
" augroup fern-custom
"   autocmd! *
"   autocmd FileType fern call s:init_fern()
" augroup END


" Show a preview window in fern with file contents
function! s:fern_preview_init() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-preview-or-nop)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:edit)\<C-w>p",
        \   "",
        \ )
  nmap <buffer><expr> j
        \ fern#smart#drawer(
        \   "j\<Plug>(fern-my-preview-or-nop)",
        \   "j",
        \ )
  nmap <buffer><expr> k
        \ fern#smart#drawer(
        \   "k\<Plug>(fern-my-preview-or-nop)",
        \   "k",
        \ )
endfunction
augroup my-fern-preview
  autocmd! *
  autocmd FileType fern call s:fern_preview_init()
augroup END


""" NERDTREE TABS -----------------------------
function s:OpenNERDTree()
  let isFile = (&buftype == "") && (bufname() != "")

  if isFile
    let findCmd = "NERDTreeFind " . expand('%')
  endif

  " open a NERDTree in this window
  edit .

  " make this the implicit NERDTree buffer
  let t:NERDTreeBufName=bufname()

  if isFile
    exe findCmd
  endif
endfunction

" map <C-n> :NERDTreeToggle<CR>

" Open/close NERDTree Tabs with \t
" nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" nmap <silent> <leader>t :call <SID>OpenNERDTree()<CR>

" Show current file in nerdtree \n
" nmap <silent> <leader>n :NERDTreeFind<CR>


" have NERDTree always open on startup
" let g:nerdtree_tabs_open_on_console_startup = 1
"
" Close current tab if there is only one window in it and it's NERDTree (default 1)
" let g:nerdtree_tabs_autoclose=0
" Open dir/file with space
" let NERDTreeMapActivateNode='<space>'

" let NERDTreeHijackNetrw=1

" NERDCOMMENTER settings
" nmap <silent> <leader>
"let g:NERDCompactSexyComs = 1
"let g:NERDTrimTrailingWhitespace = 1
noremap <leader>cc :TComment<CR>
"vnoremap <leader>cc :TComment<CR>


" auto-pairs
let g:AutoPairsMapSpace=0

"" INCSEARCH settings -----------------------------
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)

" Aux function to use with fzf in vim to search for files in the current git
" project
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" fzf settings --------------------------

" Search through all file names in this project and open it with fzf
" Using the same key as for ctrl-P plugin since I'm used to that
map <C-p> :ProjectFiles<CR>
" Search through lines of current buffer
" Replacing the default vim search with this
" nnoremap / :BLines<CR>
" Search through all buffer names with fzf
nnoremap <leader>b :Buffers<CR>
" Search through all lines in all files with Ripgrep (:Rg is provided by fzf plugin)
nnoremap <leader>l :Rg<CR>
" Search through history of opened files with fzf
nnoremap <leader>h :History<CR>
" Search through executed command history with fzf
nnoremap <leader>H :History:<CR>
" Search through all vim commands with fzf
nnoremap <leader>: :Commands<CR>
" Search through marks pane with fzf
nnoremap <leader>m :Marks<CR>
" Search for tags (in current buffer) with fzf
nnoremap <leader>> :BTags<cr>
" Search for tags (globally) with fzf
nnoremap <leader>. :Tags<cr>
" Search through all vim help docs by line with fzf
nnoremap <leader>? :Helptags<CR>

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
" nnoremap <Leader>S :SyntasticToggleMode<CR>

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


" ALE settings ---------------------------

" Needed to check vue files with eslint
let g:ale_linter_aliases = {
            \    'vue': ['vue', 'javascript'],
            \    'jsx': ['css', 'javascript']
\}

" You should explicitly add only the linters you want running since it will be
" more overhead otherwise since ALE will by default run all linteres found
" in the ale_linteres dir in the ALE repo
            " \ 'jsx': ['stylelint', 'eslint']
let g:ale_linters = {
            \ 'python': ['flake8', 'mypy'],
            \ 'javascript': ['eslint'],
            \ 'vue': ['eslint', 'vls'],
            \ 'jsx': ['eslint']
\}
let g:ale_python_mypy_options = '--ignore-missing-imports'

" Only run linters named in ale_linters settings.
" let g:ale_linters_explicit = 1

" Syntax fixers, can fix files with the ALEFix command
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \   'python': ['black', 'isort'],
" let g:ale_fixers = {
" \   'python': ['isort'],
" \   'javascript': ['eslint'],
" \   'vue': ['eslint'],
" \}
" let g:ale_python_isort_options='--profile black'

" Auto fix files on save
let g:ale_fix_on_save = 0
" Don't lint on entering a file
" I turned this off bc the deafult of on made vim very slow when switching
"   buffers
let g:ale_lint_on_enter = 0

let g:ale_virtualenv_dir_names = ['/Users/hima/Library/Caches/pypoetry/virtualenvs']

" Toggle ALE active or not
nnoremap <Leader>S :ALEToggle<CR>

" Go to next ALE error
nnoremap <Leader>a :ALENextWrap<CR>

" Gutentags settings --------------------------
" Prints when Gutentags is generating tags in the background
set statusline+=%{gutentags#statusline()} 


" Tagbar settings -----------------------------
" Main benefit of tagbar for me is that with airline, it auto-shows the
"   current tag (class/method/etc) that my cursor is currently in 
"   on the airline status bar

" Opens the tagbar side pane, and auto-closes it once you go to a tag
nmap <leader>g :TagbarOpenAutoClose<CR> 

" Context.vim settings -----------------------------
let g:context_add_mappings = 0

nnoremap <silent> <expr> <C-Y> context#util#map('<C-Y>')
nnoremap <silent> <expr> <C-E> context#util#map('<C-E>')
nnoremap <silent> <expr> zz    context#util#map('zz')
nnoremap <silent> <expr> zb    context#util#map('zb')
nnoremap <silent> <expr> zt    context#util#map_zt()

" coc settings --------------------------------

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Code actions are automated changes or fixes for an issue, such as
" automatically importing a missing symbol. Code actions can be performed on
" the word under the cursor with this mapping
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OrganizeImports` command to organize imports of the current buffer.
" Removes unused and sorts them 
command! -nargs=0 OrganizeImports   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Search workspace symbols. **useful to jump to a definition
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" Show all diagnostics.
nnoremap <silent><nowait> <leader>Ca  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>Ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>Cc  :<C-u>CocList commands<cr>
" Find symbol of current document.C
nnoremap <silent><nowait> <leader>Co  :<C-u>CocList outline<cr>
" Do default action for next item.C
nnoremap <silent><nowait> <leader>Cj  :<C-u>CocNext<CR>
" Do default action for previous iCem.
nnoremap <silent><nowait> <leader>Ck  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>Cp  :<C-u>CocListResume<CR>

let g:coc_global_extensions = [
      \'coc-python',
      \'coc-html', 
      \'coc-tsserver', 
      \]

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

