function! GitBlame()
    let cygfile = system("cygpath -m '" . expand("%:p") . "'")
    let topdir = substitute(system("git rev-parse --show-toplevel"), '\W*$', '', '')
    let relative = substitute(cygfile, topdir . '/\(.*\)', '\1', '')
    cd `=topdir`
    set co=300
    new
    silent exec "r !git blame " . relative
    normal ggdd
    set nomod
endfunction

function! GitDiff(revision)
    let cygfile = system("cygpath -m '" . expand("%:p") . "'")
    let topdir = substitute(system("git rev-parse --show-toplevel"), '\W*$', '', '')
    let relative = substitute(cygfile, topdir . '/\(.*\)', '\1', '')
    cd `=topdir`
    set co=300
    sp
    winc _
    diffthis
    vert new
    silent exec "r !git show " . a:revision . ":" . relative
    normal ggdd
    set nomod
    diffthis
    winc l
endfunction

function! GitDiffPrev()
    let cygfile = system("cygpath -m '" . expand("%:p") . "'")
    let topdir = substitute(system("git rev-parse --show-toplevel"), '\W*$', '', '')
    let relative = substitute(cygfile, topdir . '/\(.*\)', '\1', '')
    let logline = split(system("git log -2 --pretty=oneline \"" . relative . "\""), "\n")[1]
    let revision = substitute(logline, '\(\W*\) .*', '\1', '')
    set co=300
    sp
    winc _
    diffthis
    vert new
    silent exec "r !git show " . revision . ":" . relative
    normal ggdd
    set nomod
    diffthis
    winc l
endfunction

function! GitDiffVersion()
    let default = histget("input", -1)
    let revision = input("revision [" . default . "]: ") 
    if revision == ""
        let revision = default
    endif
    call histadd("input", revision)

    let cygfile = system("cygpath -m '" . expand("%:p") . "'")
    let topdir = substitute(system("git rev-parse --show-toplevel"), '\W*$', '', '')
    let relative = substitute(cygfile, topdir . '/\(.*\)', '\1', '')
    cd `=topdir`
    set co=300
    sp
    winc _
    diffthis
    vert new
    silent exec "r !git show " . revision . ":" . relative
    normal ggdd
    set nomod
    diffthis
    winc l
endfunction

function! GitLog(options)
    let cygfile = system("cygpath -m '" . expand("%:p") . "'")
    let topdir = substitute(system("git rev-parse --show-toplevel"), '\W*$', '', '')
    let g:relative = substitute(cygfile, topdir . '/\(.*\)', '\1', '')
    cd `=topdir`
    new
    silent exec "r !git log " . a:options . " " . g:relative
    normal gg
    set nomod
    set filetype=git
    command! -range -buffer -nargs=0 CmdGitCommitDiff2
            \ :call GitCommitDiff2(<line1>, <line2>)
    nnoremap <buffer> <cr> :call GitCommitDiff()<cr>
    vmap <silent> <buffer> <cr> :CmdGitCommitDiff2<cr>
endfunction

function! GitCommitDiff()
    let l = getline(".")
    let commit = substitute(l, '^[| *]*commit \(.*\)', '\1', '')
    set co=300
    new
    winc _
    exec 'edit' g:relative
    diffthis
    vert new
    silent exec "r !git show " . commit . ":" . g:relative
    normal ggdd
    set nomod
    silent exec "file " . commit . ":" . g:relative
    diffthis
    winc l
endfunction

function! GitCommitDiff2(line1, line2)
    let commit1 = substitute(getline(a:line1), '^[| *]*commit \(.*\)', '\1', '')
    let commit2 = substitute(getline(a:line2), '^[| *]*commit \(.*\)', '\1', '')
    set co=300
    new
    winc _
    silent exec "r !git show " . commit1 . ":" . g:relative
    normal ggdd
    set nomod
    silent exec "file " . commit1 . ":" . g:relative
    diffthis
    vert new
    silent exec "r !git show " . commit2 . ":" . g:relative
    normal ggdd
    set nomod
    silent exec "file " . commit2 . ":" . g:relative
    diffthis
    winc l
endfunction

function! GitCheckout()
    let cygfile = system("cygpath -m '" . expand("%:p") . "'")
    let topdir = substitute(system("git rev-parse --show-toplevel"), '\W*$', '', '')
    let relative = substitute(cygfile, topdir . '/\(.*\)', '\1', '')
    cd `=topdir`
    silent exec "!git checkout -- " . relative
endfunction


