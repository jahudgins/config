"
" Author: Jonathan Hudgins <jhudgins@gmail.com>
" Usage:
"     :p4client <client>
"       set the p4 client different than the environment
"     :p4port <server:port>
"       set the p4 port different than the environment
"     :p4edit
"       check out current file from perforce
"     :p4diff
"       text diff of current file
"     :p4vdiff
"       visual diff of current file
"     :p4filelog
"       filelog for current file
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

