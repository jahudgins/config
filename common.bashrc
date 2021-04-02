# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.1-1

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle () 
# { 
#   echo -ne "\e]2;$@\a\e]1;$@\a"; 
# }
# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# 
# alias cd=cd_func

set -o vi
shopt -s nocaseglob

# History
shopt -s histappend                      # append to history, don't overwrite it
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # Make bash append rather than overwrite the history on disk
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # Save reload hist after each cmd

export PYTHONUNBUFFERED=1
export PATH=.:/c/work/bin:$PATH:$VIMLOCATION



#######################
# P4 Vars and Aliases #
#######################

if [ -z "$P4PORT" ];
then
    export P4PORT=perforce.server.something:1666
fi

P4USER=jhudgins
P4CHARSET=utf8

export P4MERGE=$VIMLOCATION/gvim.exe
export P4MERGEUNICODE=$VIMLOCATION/gvim.exe
export P4EDITOR=$VIMLOCATION/gvim.exe

alias p4sync='unset PWD; p4 -vnet.tcpsize=524288 sync --parallel "threads=4,min=1,minsize=1"'
# alias p4list="python c:/git/ext-jhudgins/utils/scripts/p4list.py"
function p4list() {
  p4 have $(p4 opened $@ | sed -e 's/#.*//') | sed -e 's/.*- \(.*\)/\1/' | tr '\\' '/'
}
function p4l() {
  p4 opened | grep $1 | sed -e 's/#.*//'
}
function p4lv() {
  p4 opened | grep -v $1 | sed -e 's/#.*//'
}
function p4c() {
  p4 opened | sed -e 's/.* - //' | sort -u
}


function p4syncopened() {
  export tempscript=`mktemp`
  echo "#!bash" > $tempscript
  p4list | sed -e "1~300s/^/p4 sync $@ /" | sed -e 's/p4 sync/\
\
p4 sync/' >> $tempscript
  chmod +x $tempscript
  $tempscript
  rm $tempscript
}

function p4whichsync() {
  p4syncopened -n 2>&1 | grep -v "up-to-date"
}

function gv()
{
  args=""
  for i in "$@"
  do
    # echo $i
    args="$args `cygpath -m $i`"
  done
  gvim $args &
}
complete -o default -F _longopt gv

function mtags
{
  export tag_location="$1"
  shift
  echo ctags --langmap=c++:+.inl --exclude=node_modules --exclude=External --exclude=*.html --exclude=*.htm -R -f $tag_location/tags $@
  ctags --langmap=c++:+.inl --exclude=node_modules --exclude=External --exclude=*.html --exclude=*.htm -R -f $tag_location/tags $@
}

function b0
{
    export CDPATH=.:${DEVDIR0}
    export P4CLIENT=$P4CLIENT0
    export EXPANDED_TAG_DIRS=""
    for tagdir in ${TAG_DIRS[@]};
    do
        EXPANDED_TAG_DIRS+="${DEVDIR0}/${tagdir} "
    done
    alias tag="mtags ${DEVDIR0} ${EXPANDED_TAG_DIRS}"
}

export TEMP=c:/work/temp
alias ls='ls --color'

. .agent > /dev/null
ps -p $SSH_AGENT_PID | grep ssh-agent > /dev/null || {
    ssh-agent > .agent
    . .agent > /dev/null
}

function isadmin()
{
    net session > /dev/null 2>&1
    if [ $? -eq 0 ]; then echo "admin"
    else echo "user"; fi
}

# for i in `ps -eW | grep python.exe | sed -e 's/^[     ]*\([0-9]*\)[   ].*/\1/g'`; do /bin/kill -f $i; done

function gl()
{
    git ls-files --others --exclude-standard $@
    git diff --name-only $@
}

function gld()
{
    branch=$(git branch | grep \* | cut -d ' ' -f2)
    shabase=$(git merge-base $branch origin/master)

    rm -rf /c/work/diff
    olddir=/c/work/diff/old
    mkdir -p $olddir
    filelist=
    for file in $(git diff --name-only $branch..$shabase);
    do
        parentpath=$(dirname "$file")
        mkdir -p "$olddir/$parentpath"
        git show $shabase:$file > "$olddir/$file"
        filelist="$filelist $olddir/$file $file"
    done
    gv $filelist &
}

function gd()
{
    rm -rf /c/work/diff
    olddir=/c/work/diff/old
    newdir=/c/work/diff/new
    mkdir -p $olddir
    mkdir -p $newdir
    filelist=
    for file in $(git diff --name-only $1..$2);
    do
        parentpath=$(dirname "$file")
        mkdir -p "$olddir/$parentpath"
        mkdir -p "$newdir/$parentpath"
        git show $1:$file > "$newdir/$file"
        git show $2:$file > "$olddir/$file"
        filelist="$filelist $olddir/$file $newdir/$file"
    done
    gv $filelist &
}

function gbd()
{
    gd $1 $(git merge-base $1 origin/master)
}
 
 
alias gr='git checkout .; git clean -fd'
alias gvd='gv $(git diff --name-only;  git ls-files --others --exclude-standard)'
alias greview='gv $(git diff --cached --name-only)'

b0
