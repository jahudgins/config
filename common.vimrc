set backup              " keep a backup file
set writebackup         " keep a backup file
set backupdir=$workdir/backupdir
set undodir=$workdir/backupdir
set directory=$workdir/backupdir

silent! unmap 

" set runtimepath=~/vimfiles,C:\vim/vimfiles,C:\vim\vim82,C:\vim\vim82\pack\dist\opt\matchit,C:\vim/vimfiles/after,~/vimfiles/after,$configdir/vimfiles
" set runtimepath=$configdir/vimfiles,C:/Vim/vimfiles,C:/Vim/$vimversion,C:/Vim/vimfiles/after
source $configdir/vimfiles/plugin/git.vim
source $configdir/vimfiles/plugin/p4.vim
source $configdir/vimfiles/plugin/searchreplace.vim

function! Branch(client, devdir)
  call Jp4client(a:client)
  let $devdir=a:devdir
  let $logfile0='$devdir/$logsuffix0'
  let $logfile1='$devdir/$logsuffix1'
  let $logfile2='$devdir/$logsuffix2'
  cd "$devdir"
  set tags=$devdir/tags
endfunction

map ,b0 :call Branch($p4client0, $devdir0)<cr>
map ,b1 :call Branch($p4client1, $devdir1)<cr>
map ,b2 :call Branch($p4client2, $devdir2)<cr>

set nojoinspaces
set nocompatible
set shell=cmd.exe
"set shell=bash.exe
"set shellcmdflag=--login\ -c
"set sxq=\"

" BEGIN from vimrc_example.vim
" I don't like the way vimrc_example works (it seems to force line breaks on text files),
" so hard code the useful ones
"source $VIMRUNTIME/vimrc_example.vim
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  filetype plugin indent on
  augroup vimrcEx
  au!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" END from vimrc_example.vim
"
au BufRead,BufNewFile SConstruct setfiletype python

behave xterm
set selectmode=mouse
set guioptions=agimrt
set guifont=lucida_console:h10
"set guifont=courier:h7
"set lines=110
set co=120
set textwidth=0
setlocal textwidth=0
set tabstop=4
set shiftwidth=4
set noexpandtab
set nocin
set noruler
set wrapscan

let mapleader=","

let python_highlight_space_errors = 1

let temp = $workdir.'/temp'
let $temp = $workdir.'/temp'

function! GlobalGotoTag(switchWin)
  let l = getline(".")
  let file = substitute( l, '^[^	]*	\([^	]*\)	.*', '\1', '' )
  let linenumber = substitute( l, '^[^	]*	[^	]*	\([^	]*\)', '\1', '' )
  if a:switchWin==1
    winc p
  endif
  exec "e +".linenumber.  " " . file
  if a:switchWin==1
    winc p
  endif
endfunction

let relative=0
com! -nargs=* T tselect
" why do I have  ?  It doesn't seem to work right otherwise
map T :tjump <cr>
"map t :ptj <cr>
map t :call TagJumpOtherWindow()<cr>
function! TagJumpOtherWindow()
  let cw = expand("<cword>")
  winc p
  exec "tjump " . cw
  let @/ = cw
  normal z.
  winc p
endfunction

" joinspaces:  insert two spaces after a period with every joining of lines. 
set joinspaces

" lazyredraw:  do not update screen while executing macros
set lazyredraw

" laststatus:  Always show status line, even for only one buffer.
set laststatus=2

" Use ALT-D to delete all of the buffers
map ä :1,4000bdel<cr>

function! DA()
	let base=$temp."change_orig.c "
	let theirs=$temp."change_theirs.c "
	let yours=$temp."change_yours.c "
	let merged=$temp."change_merged.c "
  exec ":b1"
  exec ":w! " . base
  exec ":b2"
  exec ":w! " . theirs
  exec ":b3"
  exec ":w! " . yours
  exec ":b4"
  exec ":w! " . merged
	silent exec "! start c:\\vim\\". $vimversion . "\\gvim " . base . theirs
	silent exec "! start c:\\vim\\". $vimversion . "\\gvim " . base . yours
	silent exec "! start c:\\vim\\". $vimversion . "\\gvim " . base . merged
endfunction

function! DC()
	let orig=$temp."change_orig.c "
	let theirs=$temp."change_theirs.c "
	let yours=$temp."change_yours.c "

	sp

	normal y/^==== THEIRS
	exec ":e ". orig
	normal Gopkdgg
	exec ":w"
	exec ":e#"

	normal /^==== THEIRSy/^==== YOURS
	exec ":e ". theirs
	normal Gopkdgg
	exec ":w"
	exec ":e#"

	normal /^==== YOURSy/^<<<<
	exec ":e ". yours
	normal Gopkdgg
	exec ":w"
	exec ":e#"
	silent exec "! start c:\\vim\\vim80\\gvim " . orig . theirs
	silent exec "! start c:\\vim\\vim80\\gvim " . orig . yours

	clo
endfunction

function! DM()
  sp
  b 2
  diffthis
  vert sp
  b 3
  diffthis
  winc j
  b 4
  winc k
  set co=500
  winc =
	winc j
	normal GG/>>>>
endfunction

nmap ,da :call DA()<cr>
nmap ,dc :call DC()<cr>
nmap ,dm :call DM()<cr>
nmap ,dd :call DD()<cr>
nmap ,do :call DiffOrig()<cr>
nmap ,df :call DF()<cr>

function! DF()
	vert sp
	bn
	diffthis
	set scrollbind
	winc w
	diffthis
	set scrollbind
	set co=500
	winc =
	winc w
endfunction


function! DD()
	vert sp
	bn
	diffthis
	set nofoldenable
	set scrollbind
	winc w
	diffthis
	set nofoldenable
	set scrollbind
	set co=500
	winc =
	winc w
endfunction

function! Dset()
  set nofoldenable
  winc w
  set scrollbind
  set nofoldenable
  winc w
  set scrollbind
  set co=500
  winc =
  0
endfunction
com! -nargs=0 Dset call Dset()

com! -nargs=0 DD call DD()

nmap [p :diffput<CR>
nmap ]p :diffget<CR>

function! UndiffBuffer()
  set nofoldenable
  set foldcolumn=0
  set nodiff
  set wrap
  set noscrollbind
endfunction

function! Undiff()
  set co=120
  call UndiffBuffer()
  winc w
  set co=120
  call UndiffBuffer()
  winc w
endfunction
com! -nargs=0 Undiff call Undiff()
set diffopt=iwhite

map  :e#<cr>

function! GetFbuildFile(line)
  let mx = '^\([a-zA-Z_/\\\.0-9:\- ]*\)(\(\d\+\)): '
  let file = matchstr( a:line, mx )
  let file = substitute( file, mx, '\1', '' )
  let file = substitute( file, '\\', '/', '' )
  return file
endfunction

function! GetFbuildLineNumber(line)
  let mx = '^\([a-zA-Z_/\\\.0-9:\- ]*\)(\(\d\+\)): '
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GetMsdevFile(line)
  let mx = '^[0-9]*>\([a-zA-Z_/\.0-9:\- ]*\)'
  let file = matchstr( a:line, mx )
  let file = substitute( file, mx, '\1', '' )
  let file = substitute( file, '\\', '/', '' )
  return file
endfunction

function! GetMsdevLineNumber(line)
  let mx = '^[0-9]*>\([a-zA-Z_/\.0-9:\- ]*\)(\(\d\+\)[),]'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GetMsdevFile2(line)
  let file = expand("%:p:h") . "/" . GetMsdevFile(a:line)
  let file
  return file
endfunction

function! GotoFbuildMake()
  " exec "cd ".$DIRECTORY."\\.."
  let l = getline(".")
  let file = GetFbuildFile(l)
  let linenumber = GetFbuildLineNumber(l)
  winc p
  exec "e +" . linenumber. " " . file
  exec "cd -"
endfunction

function! GotoMsdevMake()
  exec "cd ".$DIRECTORY."\\.."
  let l = getline(".")
  let file = GetMsdevFile(l)
  let linenumber = GetMsdevLineNumber(l)
  winc p
  exec "e +" . linenumber. " " . file
  exec "cd -"
endfunction

function! GetGCCFile(line)
  let mx = '^\([a-zA-Z_/\.0-9:\- ]*\):[0-9]\+: .*'
  let line = matchstr( a:line, mx )
  let file = substitute( line, mx, '\1', '' )
  let file = substitute( file, '\\', '/', '' )
  return file
endfunction

function! GetGCCLineNumber(line)
  let mx = '^\([a-zA-Z_/\.0-9:\- ]*\):\([0-9]\+\):.*'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction


function! GotoGCCMake()
  exec "cd ".$DIRECTORY."\\.."
  let l = getline(".")
  let file = GetGCCFile(l)
  let linenumber = GetGCCLineNumber(l)
  winc p
  exec "e +" . linenumber. " " . file
  exec "cd -"
endfunction

function! GetCSharpFile(line)
  "let mx = '^\d*>\([a-zA-Z_/\.0-9:\- ]*\)(\([0-9]\+\),.*'
  let mx = '^\([a-zA-Z_/\.0-9:\- ]*\)(\([0-9]\+\),.*'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\1', '' )
  return linenumber
endfunction

function! GetCSharpNumber(line)
  "let mx = '^\d*>\([a-zA-Z_/\.0-9:\- ]*\)(\([0-9]\+\),.*'
  let mx = '^\([a-zA-Z_/\.0-9:\- ]*\)(\([0-9]\+\),.*'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GotoCSharpMake()
  let l = getline(".")
  let file = 'somewhere/' . GetCSharpFile(l)
  let linenumber = GetCSharpNumber(l)
  winc p
  exec "e +" . linenumber. " " . file
endfunction

function! GetUnrealFile(line)
  let mx = '^\([^:]*:   \)\([^(]*\)(\([0-9]*\)).*'
  let filename = substitute(a:line, mx, '\2', '')
  return filename
endfunction

function! GetUnrealNumber(line)
  let mx = '^\([^:]*:   \)\([^(]*\)(\([0-9]*\)).*'
  let number = substitute(a:line, mx, '\3', '')
  return number
endfunction

function! GotoUnreal()
  let l = getline(".")
  let file = GetUnrealFile(l)
  let linenumber = GetUnrealNumber(l)
  winc p
  exec "e +" . linenumber. " " . file
endfunction

nmap zb 85hzs
nmap zf 85l10hzs10l
nmap ,e :Sexplore<CR>
nmap  :e#<cr>
nmap ,E :Explore<CR>
nmap ,l :ls<cr>

nmap ,q :bd<cr>
nmap ,p "*p
nmap ,P "*P
nmap ,y "*y

" Source the .vimrc
nmap ,ss :source $VIMLOCATION/../_vimrc<cr>
nmap ,sx :e $VIMLOCATION/../_vimrc<cr>
nmap ,se :e $configdir/common.vimrc<cr>

map ,c :Calendar<cr>
" C++ comments
"map ,c mz^i/*<ESC>$a*/<ESC>`z
"map ,C mz^2x$Xx`z
"vmap ,c <ESC>`<i/*<ESC>`>a*/<ESC>
"vmap ,C <ESC>`<2x`>h2x

" Movement between buffers
map ,k k
map ,j j
map ,u 
map ,h h

"VMAPs
" Sort the visually selected range by pressing "s"
vmap s :!sort<cr>
vmap S :!c:\\cygwin\\bin\\sort -r<cr>
vmap r :!c:\\cygwin\\bin\\sort -k2 -t.<cr>

vmap / y/<C-R>"<CR>


nmap ,r0 :e $temp/search0<CR>:call MapGotoBuff()<cr>
nmap ,r1 :e $temp/search1<CR>:call MapGotoBuff()<cr>
nmap ,r2 :e $temp/search2<CR>:call MapGotoBuff()<cr>
nmap ,r3 :e $temp/search3<CR>:call MapGotoBuff()<cr>
nmap ,r4 :e $temp/search4<CR>:call MapGotoBuff()<cr>
nmap ,r5 :e $temp/search5<CR>:call MapGotoBuff()<cr>
nmap ,r6 :e $temp/search6<CR>:call MapGotoBuff()<cr>
nmap ,r7 :e $temp/search7<CR>:call MapGotoBuff()<cr>
nmap ,r8 :e $temp/search8<CR>:call MapGotoBuff()<cr>
nmap ,r9 :e $temp/search9<CR>:call MapGotoBuff()<cr>
nmap ,rf :call Filter()<CR>
nmap ,rs :call Syntax()<CR>

nmap ,xa :e c:/phx/Dev-Main/tags<cr>
nmap ,xb :echo unused
nmap ,xc :e c:/work/scratch.cpp<CR>
nmap ,xe :e!<cr>
nmap ,xg :call FilterLinesWithWord()<cr>
nmap ,xh :echo unused
nmap ,xj :e $logfile0<cr>
nmap ,xk :e $logfile1<cr>
nmap ,xl :e $logfile2<cr>
"C:\Users\jhudgins\AppData\Local\UnrealGameSync\phx_jhudgins_dev-main_sds-jhudgins2@phx_jhudgins_dev-main_sds-jhudgins2.review.log"
nmap ,xt :e c:/work/todo.md<cr>
nmap ,xy :e c:/work/notes.md<cr>

nmap ,xx :let @*=expand("%:p")<cr>

nmap ,ta :call Jp4annotate()<cr>
nmap ,td :call Jp4vdiff()<cr>
nmap ,tf :call Jp4filelog()<cr>
nmap ,ti :silent !p4 edit "%:p"<cr>
nmap ,to :call Jp4opened()<cr>
nmap ,tr :silent !p4 revert "%:p"<cr>

nmap ,xp :bp<cr>
nmap ,xn :bn<cr>
nmap ,xo :execute 'edit' substitute(substitute(@*, "^.", "", ""), "...$", "", "")<cr>

nmap ,xq :call UndiffBuffer()<cr>:q<cr>:call UndiffBuffer()<cr>:q<cr>:set co=120<cr>

nmap ,x0 :e c:/work/scratch0.txt<CR>
nmap ,x1 :e c:/work/scratch1.txt<CR>
nmap ,x2 :e c:/work/scratch2.txt<CR>
nmap ,x3 :e c:/work/scratch3.txt<CR>
nmap ,x4 :e c:/work/scratch4.txt<CR>
nmap ,x5 :e c:/work/scratch5.txt<CR>
nmap ,x6 :e c:/work/scratch6.txt<CR>
nmap ,x7 :e c:/work/scratch7.txt<CR>
nmap ,x8 :e c:/work/scratch8.txt<CR>
nmap ,x9 :e c:/work/scratch9.txt<CR>
nmap ,x- :e c:/work/scratch0.py<CR>
nmap ,xJ :%y<cr>:new<cr>p:%!python -mjson.tool<cr> 

function! MakeOut( filename )
	exec ":e " . a:filename
	call MakeBuffer()
   normal z
endfunction

function! MakeBuffer()
  normal! gg
  exec "/): error\\|failed"
  nnoremap <buffer> <cr> :call GotoFbuildMake()<cr>
endfunction

function! MakeGCCErr()
  normal! gg
  exec "/: error:"
  nnoremap <buffer> <cr> :call GotoGCCMake()<cr>
  nnoremap <buffer>  :call GotoGCCMake()<cr>
endfunction

function! MakeGCCOut( filename )
  exec ":e " . a:filename
  call MakeGCCErr()
endfunction

function! MakeCSharp()
  normal! G
  exec "?: error "
  nnoremap <buffer> <cr> :call GotoCSharpMake()<cr>
endfunction

function! MakeUnreal()
  normal! G
  exec "/: error "
  nnoremap <buffer> <cr> :call GotoUnreal()<cr>
endfunction

"nmap ,xxr :call MakeOut("Project/NET/Xbox\ Release/BuildLog.htm")<CR>
nmap ,mu :call MakeUnreal()<CR>
nmap ,mc :call MakeCSharp()<CR>
nmap ,mo :call MakeOut( "c:/work/build.log" )<cr>
nmap ,mr :call MakeOut( "c:/perforce/branch/obj/release/BuildLog.htm" )<cr>
nmap ,md :call MakeOut( "c:/perforce/branch/obj/debug/BuildLog.htm" )<cr>
nmap ,mm :call MakeBuffer()<CR>
nmap ,mq :call MakeGCCErr()<cr>
nmap ,mt :call MakeOut( "c:/work/tty.txt" )<cr>
nmap ,xm :let g:xml_syntax_folding = 1<cr>:setlocal foldmethod=syntax<cr>:e!<cr>

function! OpenLine()
  let l = getline(".")
  let f = substitute( l, '/cygdrive/\(.\)/\(.*\)', '\1:/\2', '' )
  exec ":e " . f
endfunction

function! FilterLinesWithWord()
  let w = expand("<cword>")
  exec ":g/" . w . "/d"
endfunction

nmap ,wq :w<cr>:q!<cr>:q<cr>:q<cr>
nmap ,ww :w<cr>
nmap ,wk k
nmap ,wj j
nmap ,wa _
nmap ,w= =
nmap ,wd :set co=300<cr>=100+
nmap ,wf :set co=300<cr>:set nowrap<cr>
nmap ,ws :set co=120<cr>:set wrap<cr>

function! DS()
	set scrollbind
	winc w
	set scrollbind
	set co=500
	winc =
	winc w
endfunction

nmap ,xz :call DS()<cr>

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()



function! AlphaBlankDxt()
    exec ":%!xxd<cr>"
    exec ":9,$s/: .... .... .... ..../: ffff ffff ffff ffff/g<cr>"
    exec "Gdd"
    exec ":%!xxd -r<cr>"
    exec ":w<cr>"
endfunction
"nmap ,ad :call AlphaBlankDxt()
nmap ,ad :%!xxd<cr>:9,$s/: .... .... .... ..../: ffff ffff ffff ffff/g<cr>Gdd:%!xxd -r<cr>:w<cr>:bn<cr>
nmap ,aa :%!xxd<cr>:9,$s/ .... .... .... ....  / ffff ffff 0000 0000/g<cr>Gdd:%!xxd -r<cr>:w<cr>:bn<cr>
nmap ,an :%!xxd<cr>:9,$s/: .... .... .... .... \(.... .... .... ....\)  / \1 ffff ffff 0000 0000/g<cr>Gdd:%!xxd -r<cr>:w<cr>:bn<cr>
nmap ,ar yypppdf{f,Dk0df,f,Dk0d2f,f,Dkd3f,f}DJJJj

" map v 0yf<f<p0f<hcf<,f cw,,f<cw,,,,,,,,,,,,,,,,,,,,,,,* My Contacts ::: listreplace,* ,f>xxj

function! UniqueProcmonFiles()
    exec '%s/"[^"]*",//'
    exec '%s/"[^"]*",//'
    exec '%s/"[^"]*",//'
    exec '%s/"[^"]*",//'
    exec '%s/,.*//'
    exec ':%!sort -u'
endfunction

nmap ,gb  :call GitBlame()<cr>
nmap ,gdh :call GitDiff("HEAD")<cr>
nmap ,gdo :call GitDiff("origin")<cr>
nmap ,gdp :call GitDiffPrev()<cr>
nmap ,gdv :call GitDiffVersion()<cr>
nmap ,gla :call GitLog("--follow")<cr>
nmap ,glb :call GitLog("--first-parent")<cr>
nmap ,glg :call GitLog("--graph")<cr>
nmap ,gln :call GitLog("")<cr>
nmap ,gc :call GitCheckout()<cr>

" silent normal ,b0
