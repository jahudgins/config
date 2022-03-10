"
" Author: Jonathan Hudgins <jhudgins@gmail.com>
" Usage:
"     :Jp4client <client>
"       set the p4 client different than the environment
"     :Jp4edit
"       check out current file from perforce
"     :Jp4vdiff
"       visual diff of current file
"
"*****************************************************************
function! Jp4client(client)
    let $P4CLIENT=a:client
endfunction

"*****************************************************************
function! Jp4edit()
    silent exec ":!p4 edit " . expand("%:p")
endfunc

"*****************************************************************
function! Jp4vdiff_file(filename, fileversion)
    set co=500
    resize
    split
    winc _
    diffthis
    set scrollbind
    vnew
    set buftype=nowrite
    silent exec ":%!p4 print -q " . a:filename . a:fileversion
    diffthis
    set scrollbind
endfunc

function! Jp4vdiff()
    let filename = expand("%:p")
	call Jp4vdiff_file(filename, '')
endfunc

"*****************************************************************
function! Jp4vdepotdiff(depot)
    set co=500
    resize
    split
    winc _
    diffthis
    set scrollbind
    let filename = a:depot + substitute(expand("%:p"), '\([\\]*\)\', '')
    vnew
    set buftype=nowrite
    silent exec ":%!p4 print -q " . filename
    diffthis
    set scrollbind
endfunc

"*****************************************************************
function! Jp4describe(changeNum)
    new
    set buftype=nowrite
    silent exec ":%!p4 describe -du " . a:changeNum
    set syntax=diff
endfunc

"*****************************************************************
function! Jp4filelog_diff()
    let line = getline(".")
    let mx = '^\.\.\. #\([0-9]*\) .*'
    let file_version = substitute(line, mx, '\1', '')
	let filename = b:filename
	new
    exec ':e ' . filename
	call Jp4vdiff_file(filename, '\#' . file_version)
endfunc

"*****************************************************************
function! Jp4filelog()
    let filename = expand("%:p")
    new
    let b:filename = filename
    set buftype=nowrite
    silent exec ":%!p4 filelog " . filename
	set syntax=logtalk
    nnoremap <buffer> <cr> :call Jp4filelog_diff()<cr>
endfunc

"*****************************************************************
function! Jp4get_change()
    let line = getline(".")
    let mx = '^\([0-9]*\)'
    let changelist = matchstr(line, mx)
    return changelist
endfunc

"*****************************************************************
function! Jp4annotate_describe()
    let changelist = Jp4get_change()
    call Jp4describe(changelist)
endfunc

"*****************************************************************
function! Jp4annotate()
    let filename = expand("%:p")
    new
    let b:filename = filename
    set buftype=nowrite
    silent exec ":%!p4 annotate -c " . b:filename
    nnoremap <buffer> <cr> :call Jp4annotate_describe()<cr>
    set syntax=cpp
endfunc

"*****************************************************************
function! Jp4opened_base()
    let depot_file = substitute(getline("."), '^\(.*\)#.*', '\1', '')
endfunc

"*****************************************************************
function! Jp4opened_local()
    let depot_file = substitute(getline("."), '^\(.*\)#.*', '\1', '')
    let have = system('p4 have ' . depot_file)
    return substitute(have, '^.* - \(.*\)$', '\1', '')
endfunc

"*****************************************************************
function! Jp4opened_open()
	let filename = Jp4opened_local()
    new
    exec ':e ' . filename
endfunc

"*****************************************************************
function! Jp4opened_diff()
	let filename = Jp4opened_local()
endfunc

"*****************************************************************
function! Jp4opened()
    new
    set buftype=nowrite
    silent exec ":%!p4 opened"
    nnoremap <buffer> <cr> :call Jp4opened_open()<cr>
    nnoremap <buffer> d :call Jp4opened_diff()<cr>
    set syntax=ChangeLog
endfunc


nmap ,to :call Jp4opened()<cr>

command! -nargs=1 PDescribe :call Jp4describe(<args>)
command! -nargs=1 PEdit :!p4 edit <args>
