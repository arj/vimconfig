if has('gui_running')
	set bg=light
else
	set bg=dark
endif

set tabstop=4
set noicon
set mouse=a
"set paste
set number
"set notitle
set ttyfast
set showcmd
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

filetype plugin on
filetype indent on

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
"endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 autocmd BufRead *.txt set tw=78

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gunzip")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
  autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre			*.gz call GZIP_appre("gunzip")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
  autocmd FileAppendPost		*.gz call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    let ch_save = &ch
    set ch=2
    execute "'[,']!" . a:cmd
    set nobin
    let &ch = ch_save
    execute ":doautocmd BufReadPost " . expand("%:r")
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      execute "!" . a:cmd . " <afile>:r"
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    execute "!" . a:cmd . " <afile>"
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

 " Store folds and such
 au BufWinLeave * silent! mkview
 au BufWinEnter * silent! loadview

 augroup vimrc
   au BufReadPre * setlocal foldmethod=indent
   au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
 augroup END


 augroup erlang
	 autocmd BufReadPost *.core set filetype=erlang
 augroup END
endif " has("autocmd")

" map <C-M> :!make<CR>
" map <C-L> :!./stpa examples/testkb.ljs<CR>

" source ~/.vim/a.vim

hi CursorLine   cterm=NONE ctermbg=brown ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=brown ctermfg=white guibg=darkred guifg=white
" set cursorline

set tags=./tags,tags

set foldmethod=syntax
set foldlevelstart=1

" Adding simpler commands for switching windows
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

nmap <silent> <A-S> :w<CR>

" Helping Tab commands

set wildmode=longest:full
set wildmenu

" Easier search patterns
set smartcase
set ignorecase

map <F6> :nohl<CR>

" Compilation stuff
map <F5> :make<CR>
map <F3> :make<CR>
map cn <esc>:cn<cr>
map cp <esc>:cp<cr>
set autowrite
map <F9> :!./run<CR>

set shiftwidth=4

" Options for latex-suite
let g:Tex_UseMakefile=1

set so=7

set switchbuf=useopen

nnoremap <silent> <C-a> :CommandT<CR>

map <space> /
map <c-space> ?
