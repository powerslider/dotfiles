
" vim: fdm=marker sw=4
" Basic options
"####################################################################
""{{{1 Basic options in vim
let mapleader = "\<Space>"

scriptencoding utf-8

let mapleader = "\<Space>"

call plug#begin()

"comment/uncomment lines of code
Plug 'scrooloose/nerdcommenter'

"see files and directories in a tree structure inside vim
Plug 'scrooloose/nerdtree'

Plug 'ervandew/supertab'

"powerful on-the-fly autocompletion
Plug 'Valloric/YouCompleteMe'

"fuzzy file finder
Plug 'kien/ctrlp.vim'

"syntax checking for various languages
Plug 'scrooloose/syntastic'

"ending different constructs in different languages
Plug 'tpope/vim-endwise'

"autocompleting parentheses, brackets, quotes, XML tags, and more
Plug 'tpope/vim-surround'

"create custom snippets for every language, supports vim-snippets engine
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"auto-aligning of code and text
Plug 'godlygeek/tabular'

call plug#end()

"{{{2 Filetype options
filetype on
filetype plugin on
filetype indent on
"}}}
"

set numberwidth=1                               "make it low so it doesn't get too much space

syntax on
set showfulltag                                 " Show the full tag when we are doing search completion
set showcmd                                     " Show the command we are typing
set nowrap                                      " make this default and switch it on if we need.
set linebreak                                   " this doesn't just cut our words but wraps nice
set lazyredraw                                  " speed up macros

" If tabstop > softtabstop, vim uses tabs and spaces for TAB in insert mode
" else if tabstop = softabstop, vim always uses tabs for TAB,
" else if expandtab is set, vim uses spaces for TAB in insert mode
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4                                " numbers of spaces to (auto)indent

"{{{ Searching options
set hlsearch                                    " highlight searches
set incsearch                                   " do incremental searching
set ignorecase                                  " no case sensitivity 
"}}}
"

set ruler                                       " show the cursor position all the time
set scrolloff=3                                 " Keep 3 lines when we are scrolling
set fileformat=unix                             " set it default to Unix. So many problems with that :("
set clipboard=unnamed                           " just copy to the clipboard as default!!

set listchars=tab:·\ ,trail:·,nbsp:· 
"Uncomment that if you want to see hmm mostly everything :)(thanks to mauke
"from IRC for that.)
"let &lcs = "tab:\273\255,trail:\267,eol:\266,nbsp:\u23b5,precedes:\u2190,extends:\u2192"

set list                                        " display whitespaces
set autowriteall                                " saves the current file when switching buffers

set mouse=nic                                   " disable selecting text in visual mode with the mouse

"{{{2 No bad visual annoying and beeps
set novisualbell
set visualbell t_vb= 
if has("autocmd")
    autocmd GUIEnter * set visualbell t_vb=
endif
"}}}


set whichwrap+=<,>,[,]                          " wrap on these symbols
                                                " WARNING: do not set 'h' or 'l' because it could have unexpected side effects (like breaking plugins, or changing how common key mappings work).

set wildmenu                                    " use the cool tab completion menu
set wildignore+=*.o,*~,.lo                      " ignore files with these extensions when using the cool tab completion menu

set suffixes+=.in,.a
set suffixes+=.lo,.o,.moc,.la,.closure,.loT

set backspace=indent,eol,start                  " make backspace delete lots of things

set backup                                      " keep a backup file
set backupdir=~/tmp/                            " backup dir for backup file

set number                                      " show line numbers

set viminfo='1000,f1,:1000,/1000                " enable nice big viminfo file
                                                " NOTE: The viminfo file is used to store:
                                                " - The command line history.
                                                " - The search string history.
                                                " - The input-line history.
                                                " - Contents of non-empty registers.
                                                " - Marks for several files.
                                                " - File marks, pointing to locations in files.
                                                " - Last search/substitute pattern (for 'n' and '&').
                                                " - The buffer list.
                                                " - Global variables.

set history=500                                 " history count

set showmatch                                   " highlight matching parens

set spell                                       " do spell checking for English
silent set spelllang+=en                        " set English language silently
hi clear SpellBad
hi SpellBad cterm=underline
hi Error NONE

"colorscheme inkpot                              " set colorscheme

set autoindent                                  " copy the indentation from the previous line when starting a new line
set smartindent                                 " automatically inserts one extra level of indentation in some cases, and works for C-like files

"{{{Enable folds
if has("folding")
    set foldenable
    set foldlevel=2
    set foldmethod=indent                       " groups of lines with the same indent form a fold
endif
"}}}

"}}}
if $TERM=='screen-256color-bce'
   exe "set title titlestring=vim:%f"
   exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif
"{{{1

"{{{2 Status bar options(ciaranm's vimrc)
set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%2*0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset"
"}}}

"{{{2 Window title options(ciaranm''s vimrc)
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                                              " file name
    set titlestring+=%h%m%r%w                                         " flags
    set titlestring+=\ -\ %{v:progname}                               " program name
    set titlestring+=\ -\ %{substitute(getcwd(),\ $HOME,\ '~',\ '')}  " working directory
endif
"}}}
""{{{2 Extra terminal things
if (&term =~ "xterm") && (&termencoding == "")
    set termencoding=utf-8
endif
if &term =~ "xterm"
    " use xterm titles
    if has('title')
        set title
    endif
    " change cursor colour depending upon mode
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif
"}}}
"}}}
""{{{1
"Gui options 
""{{{2
"Gui options which I like(Clean and simple)
if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
end
"}}}
""{{{2
if has("gui_running")
    " See ~/.gvimrc
    set guifont=Consolas\ 10.5  " use this font
    set guicursor=
    set guicursor+=n-v-c:block-Cursor/lCursor-blinkon0,
                \ve:ver35-Cursor-blinkon0,
                \o:hor50-Cursor-blinkon0,
                \i-ci:ver25-Cursor/lCursor-blinkon0,
                \r-cr:hor20-Cursor/lCursor-blinkon0,
                \sm:block-Cursor-blinkon0
    set lines=30      " height = 50 lines
    set columns=100        " width = 100 columns
    set keymodel=
endif
""}}}
"}}}
source ~/.vim/filetypes.vim
source ~/.vim/maps.vim
source ~/.vim/contents.vim
" Added and stolen from Radev lately
source ~/.vim/cyrillic.vim
"{{{ Options for the plugins
let python_highlight_all=1
" Settings for tagbar
let g:tagbar_compact = 1
let g:tagbar_width = 28
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1

"Close NERDTree if open after we open a new file
let g:NERDTreeQuitOnOpen=1

"Doxygen
let g:load_doxygen_syntax=1
let g:doxygen_enhanced_color=1

"Latex options
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_ViewRule_pdf="kpdf"

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"}}}
"-----------------------------------------------------------------------
" final commands
"-----------------------------------------------------------------------
" turn off any existing search
if has("autocmd")
    au VimEnter * nohls
endif
command! -nargs=+ Abb :call functions#Abbreviate(<f-args>)
"Spot any double word, which are really hard to find. Especially useful for latex and plain text
au Syntax * syn match Error "\c\<\(\a\+\)\_s\+\1\>"
"This will indent and close the brace when we are at the end of the line for a
"function"
"inoremap <expr> <CR> (col("$")==col(".") ? "\<ESC>=a{\<C-O>o" : "\<CR>")
"Highlight extra whitespace
au Syntax * syn match Error /\s\+$\| \+\ze\t/  " highlight extra whitespace
let java_highlight_java_lang_ids=1
let java_highlight_java_io=1
" Append modeline after last line in buffer.
function! AppendModeline()
  let save_cursor = getpos('.')
  $put =printf(&commentstring, ' vim: set ts='.&tabstop.' sw='.&shiftwidth.' tw='.&textwidth.': ')
  call setpos('.', save_cursor)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
"This deletes the space after the iabrev i don't like sometimes.
"{{{Getchar function + Eathchar - a neat way for iabbrev that eat a space
fun! Eatchar(pat)
   let c = Getchar()
   return (c =~ a:pat) ? '' : c
endfun
fun! Getchar()
  let c = getchar()
  if c != 0
    let c = nr2char(c)
  endif
  return c
endfun
command! -nargs=+ Iabbr execute "iabbr" <q-args> . "<C-R>=Eatchar('\\s')<CR>"
"}}}
command! -nargs=0 FindTags :call functions#FindTags()
" Bring us to the directory of the file we are editing
command! CD :cd %:h
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"Store the session on exit
if has("autocmd")
    au VimLeave * mksession! ~/.vimsession
endif

"More on this option here http://www.johnhawthorn.com/2012/09/vi-escape-delays/
set ttimeoutlen=0

let g:loaded_syntastic_java_javac_checker=1
let g:loaded_syntastic_java_checkstyle_checker=1
"turtle filetypes
augroup filetypedetect
    au BufNewFile,BufRead *.n3  setfiletype n3
    au BufNewFile,BufRead *.ttl  setfiletype n3
    au BufNewFile,BufRead *.confluence  setfiletype confluencewiki
augroup END

" Save folds as described here
" http://vimrc-dissection.blogspot.com/2014/10/save-state-of-folds-mkview.html
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview 

"let g:ycm_key_list_select_completion = ['<c-n>', '<down>']
"let g:ycm_key_list_previous_completion = ['<c-p>', '<up>']
"let g:supertabdefaultcompletiontype = '<c-n>'

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

vmap em :call ExtractMethod()<CR>
function! ExtractMethod() range
  let name = inputdialog("Name of new method:")
  '<
  exe "normal! O\<BS>void " . name ."()\<CR>{\<Esc>"
  '>
  exe "normal! oreturn ;\<CR>}\<Esc>k"
  s/return/\/\/ return/ge
  normal! j%
  normal! kf(
  exe "normal! yyPi// = \<Esc>wdwA;\<Esc>"
  normal! ==
  normal! j0w
endfunction

"Use Ctrl+S for saving, also in Insert mode and in Visual mode
nmap <C-s> :w!<CR>
imap <C-s> <Esc>:w!<CR>a
vmap <C-s> <esc>:w!<CR>gv

"highlight function
nmap fu V/{<CR>%

map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>

map <C-n> :NERDTreeToggle<CR>

nmap ; :
