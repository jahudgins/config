"
" Author: Jonathan Hudgins <jhudgins@gmail.com>
" Usage:
"     :Jp4client <client>
"       set the p4 client different than the environment
"     :Jp4port <server:port>
"       set the p4 port different than the environment
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
function! Jp4port(port)
    let $P4PORT=a:port
endfunc

"*****************************************************************
function! Jp4edit()
    silent exec ":!p4 edit " . expand("%:p")
endfunc

"*****************************************************************
function! Jp4vdiff()
    set co=500
    resize
    split
    winc _
    diffthis
    set scrollbind
    let filename = expand("%:p")
    vnew
    set buftype=nowrite
    silent exec ":%!p4 print -q " . filename
    diffthis
    set scrollbind
endfunc

"*****************************************************************
function! Jp4filelog()
    let filename = expand("%:p")
    new
    set buftype=nowrite
    silent exec ":%!p4 filelog " . filename
endfunc

"*****************************************************************
function! Jp4describe(changeNum)
    new
    set buftype=nowrite
    silent exec ":%!p4 describe -du " . a:changeNum
endfunc

command! -nargs=1 PDescribe :call Jp4describe(<args>)
