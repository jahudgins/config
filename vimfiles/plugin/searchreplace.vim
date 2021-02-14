set grepprg=grep
" MyGrep command
"noremap #9 :call MyGrep($RW, 0, 1, 1, "*.h", "")<cr>
"noremap #8 :call MyGrep($SCE, 0, 1, 1, "*.h", "")<cr>
"noremap #7 :call MyGrep($DIRECTORY, 0, 1, 0, "*.*", "")<cr>
"noremap #6 :call MyGrepLocal(0, 1)<cr>
"noremap #5 :call MyGrep($DIRECTORY, 0, 1, 1, "*.*", "-i")<cr>

"noremap #2 :call MyGrep($DIRECTORY, 0, 1, 1, "*.*", "--exclude=tags --exclude=statcov.txt -I -i")<cr>
"noremap #3 :call MyGrep($DIRECTORY, 0, 1, 1, "*.*", "--exclude=tags --exclude=statcov.txt -I")<cr>
" noremap #4 :call MyGrep(g:BRANCH, 0, 1, 1, "*.*", "-I")<cr>
" noremap #2 :call MyGrepLocal(0, 1, "", 2)<cr>
noremap #3 :call MyCSearch()<cr>
noremap #4 :call MyGrepLocal(0, 1, "*.*", "-I -i --exclude=tags --exclude-dir='node_modules' --exclude='*.map' --exclude-dir='.git'", 0)<cr>
noremap #5 :call MyGrepLocal(0, 1, "*.cpp", "-I -i", 1)<cr>

" Globally substitutes the current word for something typed in
function! SubstCurrentWord() 
 normal! mp 
 let name = input("Text to substitute for current word: ") 
 exec "%s/" . expand("<cword>") . "/" .
 name . "/g" : normal! 'p
endfunction
noremap ;xw :call SubstCurrentWord()

function! CygwinizePath( path )
  let path = substitute( a:path, "\\", "\/", "g" )
  return path
endfunction

function! MyCSearch()
  let flags = "-n -i"
  let cw = expand("<cword>")
  call histadd("input", cw)

  exec "let wo = input(\"Text to search for [".cw."] : \") "
  if wo==""
    let wo = cw
  else
    call histadd("input", wo)
  endif

  let searchindex = input("Search results in 0-9 [ 0 ]") 
  if searchindex==""
    let searchindex=0
  endif
  let resultfile = g:temp."/search".searchindex

  silent exec ":! csearch " . flags . " \"".wo."\" | sed -e 's/$//' > " . resultfile

  winc p
  exec ": e " . resultfile
  g:relative = 0
  call MapGotoBuff()
endfunction



" find the path of the current file
function! MyGrepLocal( background, inputPath, pattern, extraFlags, include )
"  let mx = '^\([a-zA-Z/\.0-9]\+\\\)'
"  let path = matchstr( path, mx )
"  let path = substitute( path, mx, '\1', '' )
  let path=expand("%:p:h")
  let path = substitute( path, "\\", "\/", "g" )
  call MyGrep(  path, 0, a:background, a:inputPath, a:pattern, a:extraFlags, a:include )
endfunction

" Ask for a word and path and grep for it!
function! MyGrep(path, relative, background, inputPath, pattern, extraFlags, include)
 let path = CygwinizePath( a:path )
 normal! mp 
 let cw = expand("<cword>")

 if a:inputPath==1
   call histadd("input", path)
   let pa = input("Path to search [" . path . "]") 
   if pa==""
     let pa = path
   endif
 else
   let pa = path 
 endif
 let pa = "\"" . pa . "\"*"

 call histadd("input", cw)
 exec "let wo = input(\"Text to search for [".cw."] : \") "
 if wo==""
   let wo = cw
 else
   call histadd("input", wo)
 endif

 let flags = "-Hnsr " . a:extraFlags
 if a:include==1
   let pat = input("File Pattern [".a:pattern."] :")
   if pat==""
     let pat = a:pattern
   endif
   let flags = flags . " --include=".pat
 endif

 let searchindex = input("Search results in 0-9 [ 0 ]") 
 if searchindex==""
   let searchindex=0
 endif
 let g:relative = a:relative
 let resultfile = g:temp."/search".searchindex
 if a:background==1
   silent exec ":! rm " . resultfile
   silent exec ":! start /B grep " . flags . " \"".wo."\" " .pa. " >".resultfile
 else
   silent exec ":! rm " . resultfile
   echo ":! grep " . flags . " \"".wo."\" " .pa. " >".resultfile
   silent exec ":! grep " . flags . " \"".wo."\" " .pa. " >".resultfile
   winc p
   exec ": e " . g:temp."/search".searchindex

   let b:relative = a:relative
   nnoremap <buffer> <cr> :call GrepGotoFile(1)<cr>
   nnoremap <buffer>  :call GrepGotoFile(0)<cr>
   winc p
   exec ": e " . g:temp."/search".searchindex

   let b:relative = a:relative
   nnoremap <buffer> <cr> :call GrepGotoFile(1)<cr>
   nnoremap <buffer>  :call GrepGotoFile(0)<cr>
   let @/ = wo
  "cf c:/temp/errors.vim
 endif
endfunction

function! MapGotoBuff()
  nnoremap <buffer> <cr> :call GrepGotoFile(1)<cr>
  nnoremap <buffer>  :call GrepGotoFile(0)<cr>
  let b:relative = g:relative
endfunction

function! GetFile( line )
  let mx = '^\([-_a-zA-Z/.0-9 ]\+\):'
  let a:line
  let line = matchstr( a:line, mx )
  let line
  let file = substitute( line, mx, '\1', '' )
  let file
  return file
endfunction

function! GetLineNumber( line )
  let mx = '^\([-_a-zA-Z/.0-9 ]\+\):\(\d\+\)'
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GetFileAbs( line )
  if has('win32')
    let mx = '^\(.:[/\\][-_a-zA-Z/\\.0-9 ]\+\):'
  else
    let mx = '^\([/\\][-_a-zA-Z/\\.0-9 ]\+\):'
  endif
  let line = matchstr( a:line, mx )
  let file = substitute( line, mx, '\1', '' )
  return file
endfunction

function! GetLineNumberAbs( line )
  if has('win32')
    let mx = '^\(.:[/\\][-_a-zA-Z/\\.0-9 ]\+\):\(\d\+\)'
  else
    let mx = '^\([/\\][-_a-zA-Z/\\.0-9 ]\+\):\(\d\+\)'
  endif
  let line = matchstr( a:line, mx )
  let linenumber = substitute( line, mx, '\2', '' )
  return linenumber
endfunction

function! GrepGotoFile( thiswin )
  let l = getline(".")
  if b:relative==1
    let file = GetFile(l)
    let linenumber = GetLineNumber(l)
  else
    let file = GetFileAbs(l)
    let linenumber = GetLineNumberAbs(l)
  endif
  if a:thiswin==1
    winc p
  endif
  exec "e +" . linenumber. " " . file
endfunction

" Globally substitutes the current visual selection for something typed in
function! SubstHighlight()
 normal! mp
 let name = input("Text to substitute for visual selection: ")
 exec "%s/" . @x . "/" . name . "/g"
 normal! 'p

endfunction
vmap ;xv :call SubstHighlight()


" filter current file
function! Filter()
 let cw = expand("<cword>")
 call histadd("input", cw)
 exec "let wo = input(\"Text to filter [".cw."] : \") "
 if wo==""
   let wo = cw
 else
   call histadd("input", cw)
 endif
 let path=expand("%:p")
 let path = substitute( path, "\\", "\/", "g" )
 call histadd("input", path)
 let pa = input("Path to search [" . path . "]") 
 if pa==""
   let pa = path
 endif
 normal mp
 new
 put=path
 silent exec ":r! grep -ns \"" . wo . "\" " .pa
 set nomod
 let @/ = wo
endfunction


" define syntax
function! Syntax()
 let cw = expand("<cword>")
 call histadd("input", cw)
 let wo = input("Text to create syntax [".cw."] : ")
 if wo==""
   let wo = cw
 else
   call histadd("input", cw)
 endif
 let numsyn = input("which syntax 0-9 [0]?") 
 if numsyn=="" || numsyn == "0"
   let syntype = "Underlined"
 elseif numsyn == "1"
   let syntype = "DiffAdd"
 elseif numsyn == "2"
   let syntype = "DiffChange"
 elseif numsyn == "3"
   let syntype = "DiffDelete"
 elseif numsyn == "4"
   let syntype = "Folded"
 elseif numsyn == "5"
   let syntype = "FoldColumn"
 elseif numsyn == "6"
   let syntype = "Statement"
 elseif numsyn == "7"
   let syntype = "Special"
 elseif numsyn == "8"
   let syntype = "WildMenu"
 else " if numsyn == "9"
   let syntype = "WarningMsg"
 endif
 exec "sy match " . syntype . " /" . wo . "/"
endfunction
