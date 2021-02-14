autocmd BufWinEnter,BufNewFile * silent tabo

let config="~/Dev/users/jhudgins/config"

set backup              " keep a backup file
set writebackup         " keep a backup file
set backupdir=~/work/backups                 " For backup file
set directory=~/work/backups                 " For swap file

function! BranchFoundation()
  cd ~/dev/KeystoneFoundation
  set tags=~/dev/KeystoneFoundation/tags
endfunction

map ,bf :call BranchFoundation()<cr>

set nojoinspaces
set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
behave xterm
set selectmode=mouse
set guioptions=agimrt
"set guifont=lucida_console:h14
"set guifont=courier:h7
set lines=110
set co=120
set textwidth=0
set tabstop=4
set shiftwidth=4
set expandtab
set nocin
set noruler
set wrapscan

let mapleader=","
"iab #i #include
"iab #d #define
"iab ;; {}O<BS>

let python_highlight_space_errors = 1

let temp = "~/work/temp/"
let $temp = "~/work/temp/"

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

function! GlobalOpen( scratch )
  exec ":e " . a:scratch
  nnoremap <buffer> <cr> :call GlobalGotoTag(1)<cr>
  nnoremap <buffer> o :call GlobalGotoTag(0)<cr>
endfunction

function! GlobalRefTags( scratch )
  let cw = expand("<cword>")
  silent exec ":! global -tr " .cw. " > " . a:scratch
  sp
  call GlobalOpen( a:scratch )
endfunction

function! GlobalAllTags( scratch )
  let cw = expand("<cword>")
  silent exec ":! global -ts " .cw. " > " . a:scratch
  sp
  call GlobalOpen( a:scratch )
endfunction

map ,tt :call GlobalAllTags( "~/work/glob0.txt" )<cr>
map ,tr :call GlobalRefTags( "~/work/glob0.txt" )<cr>
map ,T0 :call GlobalRefTags( "~/work/glob0.txt" )<cr>
map ,T1 :call GlobalRefTags( "~/work/glob1.txt" )<cr>
map ,T2 :call GlobalRefTags( "~/work/glob2.txt" )<cr>
map ,T3 :call GlobalRefTags( "~/work/glob3.txt" )<cr>
map ,T4 :call GlobalRefTags( "~/work/glob4.txt" )<cr>
map ,T5 :call GlobalRefTags( "~/work/glob5.txt" )<cr>
map ,T6 :call GlobalRefTags( "~/work/glob6.txt" )<cr>
map ,T7 :call GlobalRefTags( "~/work/glob7.txt" )<cr>
map ,T8 :call GlobalRefTags( "~/work/glob8.txt" )<cr>
map ,T9 :call GlobalRefTags( "~/work/glob9.txt" )<cr>

map ,i0 :call GlobalOpen( "~/work/glob0.txt" )<cr>
map ,i1 :call GlobalOpen( "~/work/glob1.txt" )<cr>
map ,i2 :call GlobalOpen( "~/work/glob2.txt" )<cr>
map ,i3 :call GlobalOpen( "~/work/glob3.txt" )<cr>
map ,i4 :call GlobalOpen( "~/work/glob4.txt" )<cr>
map ,i5 :call GlobalOpen( "~/work/glob5.txt" )<cr>
map ,i6 :call GlobalOpen( "~/work/glob6.txt" )<cr>
map ,i7 :call GlobalOpen( "~/work/glob7.txt" )<cr>
map ,i8 :call GlobalOpen( "~/work/glob8.txt" )<cr>
map ,i9 :call GlobalOpen( "~/work/glob9.txt" )<cr>


let relative=0
com! -nargs=* T tselect
" why do I have  ?  It doesn't seem to work right otherwise
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
	silent exec "! start ~/vim/vim74/gvim " . base . theirs
	silent exec "! start ~/vim/vim74/gvim " . base . yours
	silent exec "! start ~/vim/vim74/gvim " . base . merged
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

	normal /^==== THEIRSy/^==== YOURS
	exec ":e ". theirs
	normal Gopkdgg
	exec ":w"
	exec ":e#"

	normal /^==== YOURSy/^<<<<
	exec ":e ". yours
	normal Gopkdgg
	exec ":w"
	exec ":e#"
	silent exec "! start ~/vim/vim74/gvim " . orig . theirs
	silent exec "! start ~/vim/vim74/gvim " . orig . yours

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


function! GetMsdevFile(line)
  let mx = '^\s*\([a-zA-Z_/\.0-9:\- ]*\)'
  let line = matchstr( a:line, mx )
  let file = substitute( line, mx, '\1', '' )
  let file = substitute( line, '\\', '/', '' )
  return file
endfunction

function! GetMsdevLineNumber(line)
  let mx = '^\s*\([a-zA-Z_/\.0-9:\- ]*\)(\(\d\+\))'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GetMsdevFile2(line)
  let file = expand("%:p:h") . "/" . GetMsdevFile(a:line)
  let file
  return file
endfunction

function! GetMsdevFile2(line)
  let file = expand("%:p:h") . "/../" . GetMsdevFile(a:line)
  let file
  return file
endfunction

function! GotoMsdevMake( thiswin, version )
  exec "cd ".$DIRECTORY."\\.."
  let l = getline(".")
  if a:version==0
	  let file = GetMsdevFile(l)
	  let linenumber = GetMsdevLineNumber(l)
  elseif a:version==1
	  let file = GetMsdevFile2(l)
	  let linenumber = GetMsdevLineNumber(l)
  else
	  let file = GetMsdevFile3(l)
	  let linenumber = GetMsdevLineNumber(l)
  endif
  if a:thiswin==1
    winc p
  endif
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
  let mx = '^\d*>\([a-zA-Z_/\.0-9:\- ]*\)(\([0-9]\+\),.*'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\1', '' )
  return linenumber
endfunction

function! GetCSharpNumber(line)
  let mx = '^\d*>\([a-zA-Z_/\.0-9:\- ]*\)(\([0-9]\+\),.*'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GotoCSharpMake()
  let l = getline(".")
  let file = GetCSharpFile(l)
  let linenumber = GetCSharpNumber(l)
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
nmap ,s :source ~/.vimrc<cr>

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
"map ,bn :bn<cr>
"map ,bp :bp<cr>

"VMAPs
" Sort the visually selected range by pressing "s"
vmap s :!sort<cr>

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

nmap ,rg :call MyCSearch()<cr>
nmap ,rs :call MyGrepLocal(0, 1, "-I -i --exclude=tags", 0)<cr>

nmap ,xa :e ~/dev/__MAIN__/code/tags<cr>
nmap ,xb :echo unused
nmap ,xc :e ~/work/scratch.cpp<CR>
nmap ,xe :e!<cr>
nmap ,xh :echo unused
nmap ,xt :e ~/Dev/users/jhudgins/notes/bgdownloaderTest.txt<cr>
nmap ,xy :e ~/Dev/users/jhudgins/notes/notes.txt<cr>
nmap ,xu :e ++enc=utf-16le<cr>

nmap ,xx :let @*=expand("%:p")<cr>

function! SVNLog()
  let filename = system("cygpath -u '" . expand("%:p") . "'")
  new
  silent exec "r !svn log " . filename
  set nomod
endfunction

function! SVNDiff(revision)
  let filename = system("cygpath -u '" . expand("%:p") . "'")
  set co=300
  sp
  winc _
  diffthis
  vert new
  silent exec "r !svn cat " . filename . a:revision
  normal ggdd
  set nomod
  diffthis
endfunction

nmap ,vd :call SVNDiff("")<cr>
nmap ,vh :call SVNDiff("@head")<cr>
nmap ,vl :call SVNLog()<cr>

function! P4Diff()
  set co=300
  let filename = expand("%:p")
  echo filename
  sp
  diffthis
  vert new
  silent exec "r !p4 print " . filename . "\\#head"
  normal ggdd
  set nomod
  diffthis
  winc =
  winc _
endfunction

function! P4Edit()
  exec "!p4 edit " . expand("%:p")
endfunction

nmap ,xd :call P4Diff()<cr>
nmap ,xf :PFilelog<cr>
nmap ,xi :!p4 edit %<cr>
nmap ,xo :POpened<cr>
nmap ,xr :!p4 revert %<cr>

nmap ,xp :bp<cr>
nmap ,xn :bn<cr>

nmap ,xq :call UndiffBuffer()<cr>:q<cr>:call UndiffBuffer()<cr>:q<cr>:set co=120<cr>
nmap ,xs :e ~/.vimrc<cr>

nmap ,x0 :e ~/work/scratch0.txt<CR>
nmap ,x1 :e ~/work/scratch1.txt<CR>
nmap ,x2 :e ~/work/scratch2.txt<CR>
nmap ,x3 :e ~/work/scratch3.txt<CR>
nmap ,x4 :e ~/work/scratch4.txt<CR>
nmap ,x5 :e ~/work/scratch5.txt<CR>
nmap ,x6 :e ~/work/scratch6.txt<CR>
nmap ,x7 :e ~/work/scratch7.txt<CR>
nmap ,x8 :e ~/work/scratch8.txt<CR>
nmap ,x9 :e ~/work/scratch9.txt<CR>
nmap ,x- :e ~/work/quotes.txt<CR>
nmap ,xj :%y<cr>:new<cr>p:%!python -mjson.tool<cr> 

function! MakeOut( filename )
	exec ":e " . a:filename
	call MakeBuffer()
    normal z
endfunction

function! MakeBuffer()
  normal! gg
  exec "/).*error\\|failed"
  nnoremap <buffer> <cr> :call GotoMsdevMake(1, 0)<cr>
  nnoremap <buffer>  :call GotoMsdevMake(1, 1)<cr>
  nnoremap <buffer> o :call GotoMsdevMake(1, 1)<cr>
  " nnoremap <buffer>  :call GotoMsdevMake(0, 0)<cr>
endfunction

function! MakeGCCErr()
  normal! gg
  exec "/: error:"
  nnoremap <buffer> <cr> :call GotoGCCMake()<cr>
  nnoremap <buffer>  :call GotoGCCMake()<cr>
  nnoremap <buffer> o :call GotoGCCMake()<cr>
endfunction

function! MakeGCCOut( filename )
  exec ":e " . a:filename
  call MakeGCCErr()
endfunction

function! MakeCSharp()
  normal! gg
  exec "/: error "
  nnoremap <buffer> <cr> :call GotoCSharpMake()<cr>
endfunction

"nmap ,xxr :call MakeOut("Project/NET/Xbox\ Release/BuildLog.htm")<CR>
nmap ,mc :call MakeCSharp()<CR>
nmap ,mo :call MakeOut( "~/work/build.out" )<cr>
nmap ,mr :call MakeOut( "~/perforce/branch/obj/release/BuildLog.htm" )<cr>
nmap ,md :call MakeOut( "~/perforce/branch/obj/debug/BuildLog.htm" )<cr>
nmap ,mm :call MakeBuffer()<CR>
nmap ,mq :call MakeGCCErr()<cr>
nmap ,mt :call MakeOut( "~/work/tty.txt" )<cr>
nmap ,xm :let g:xml_syntax_folding = 1<cr>:setlocal foldmethod=syntax<cr>:e!<cr>

function! OpenLine()
  let l = getline(".")
  let f = substitute( l, '/cygdrive/c/\(.*\)', 'c:/\1', '' )
  exec ":e " . f
endfunction


let g:p4DefaultDiffOptions = '-du10'
let p4UseVimDiff2 = 1

nmap ,wq :w<cr>:q!<cr>:q<cr>:q<cr>
nmap ,ww :w<cr>
nmap ,wk k
nmap ,wj j
nmap ,wa _
nmap ,w= =
nmap ,wd :set co=300<cr>=100+
nmap ,wf :set co=300<cr>:set nowrap<cr>
nmap ,ws :set co=120<cr>:set wrap<cr>

runtime! plugin/*.vim
runtime! ~/work/config/vimfiles/plugin/*.vim

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

set tags=~/vs10/VC/tags,~/mssdk/Include/tags,~/code/dirs/tags

" call BranchContentPipeline()
call BranchFoundation()
syntax enable
set ai

