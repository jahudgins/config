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
export PATH=.:~/bin:~/work/bin:~/dev/config/bin:$PATH


#######################
# P4 Vars and Aliases #
#######################

export P4PORT=perflax01:1666
export P4CLIENT=jhudgins_mac
export P4MERGE='vim'
export P4MERGEUNICODE='vim'
export P4EDITOR='vim'
export P4CHARSET=utf8
export P4COMMANDCHARSET=utf8

function p4list() {
  export tempfiles=`mktemp -t p4list`
  for i in `p4 opened $@ | sed -e 's/#.*//g'`
  do
    echo `p4 where $i | sed -e 's/.* //g'`
  done
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


###############
# SVN Aliases #
###############

function svnmod() {
    svn status | grep "^[AM]" | sed -e 's/^.\{8\}/ /' | sort
}
function svnopened() {
    svn st $@ | grep -v "^\?" | sed -e 's/^.\{8\}//'
}
function svncl() { 
    export tempfile=`mktemp --tmpdir=e:/work/temp`
    svnopened > $tempfile
    gvim $tempfile
    svn cl $1 --targets $tempfile
    rm $tempfile
}
function svnci() { 
    export tempfile=`mktemp --tmpdir=e:/work/temp`
    svnopened > $tempfile
    gvim $tempfile
    for i in `cat $tempfile`;
    do
        if file $i | grep -v --quiet "CRLF\|directory";
        then
            echo File $i is not a DOS file
            rm $tempfile
            return 0
        fi
    done
    svn ci --targets $tempfile
    rm $tempfile
}

function svnmine() {
    svn log -r HEAD:0 --limit 500 | sed -n '/jhudgins/,/-----$/p'
}

function svnmonth() {
    let lastMonth=$(($1 - 1))
    let thisMonth=$1
    svn log -r {2013-$lastMonth-01}:{2013-$thisMonth-01} | sed -n '/jhudgins/,/-----$/p'
}

# svn  log -r HEAD:0 --limit 500 | sed -n '/jfugate/,/-----$/p' > /c/work/log.txt
# svn diff `cygpath -u "E:\code\wws_shared\sdk\trunk\components\wws_crashreport\uploader\uploader.h"` | sed -e 's/^Index: .*//' | sed -e 's/^==============.*//'  | patch -R -o tmp

# patch -p0 -i /e/work/save/colladaFix.diff
# svn diff --diff-cmd=diff -x -u20

function svnlog() {
    rm /e/work/log.txt
    for i in `svn log -r HEAD:0 --limit 20 | grep "^r[0-9]\+ " | sed -e 's/ .*//'`
    do
        svn log --diff -$i >> /e/work/log.txt
    done
}

function gv
{
  mvim $@
}

function mtags
{
  export tag_location="$1"
  shift
  echo ctags --langmap=c++:+.inl --exclude=node_modules --exclude=External --exclude=*.html --exclude=*.htm -R -f $tag_location/tags $@
  ctags --langmap=c++:+.inl --exclude=node_modules --exclude=External --exclude=*.html --exclude=*.htm -R -f $tag_location/tags $@
}

export DEV=~/dev

function bu
{
    export CDPATH=.:${DEV}/UBER_BOT
    export P4CLIENT=jhudgins_uber_bot_${MACHINE}
    alias tag="mtags c:/dev/UBER_BOT/code c:/dev/UBER_BOT/code"
}

function bm
{
    export CDPATH=.:${DEV}/__MAIN__
    export P4CLIENT=jhudgins_${MACHINE}
    alias ic="icode __MAIN__"
    alias tag="mtags c:/dev/__MAIN__ c:/dev/__MAIN__/code c:/dev/__MAIN__/Riot"
}

function bk
{
    export CDPATH=.:${DEV}/KeystoneClient
    export P4CLIENT=jhudgins_keystone_${MACHINE}
    alias ic="icode KeystoneClient"
    alias tag="mtags c:/dev/KeystoneClient c:/dev/KeystoneClient/Code c:/dev/KeystoneClient/Riot"
}

function bt
{
    export CDPATH=.:${DEV}/KeystoneTools
    export P4CLIENT=jhudgins_keystone_tools_${MACHINE}
    alias ic="icode KeystoneTools"
}

function bf
{
    export CDPATH=.:${DEV}/KeystoneFoundation
    export P4CLIENT=jhudgins_keystone_foundation_${MACHINE}
    alias ic="icode KeystoneFoundation"
    alias tag="mtags c:/dev/KeystoneFoundation c:/dev/KeystoneFoundation/Code c:/dev/KeystoneFoundation/Riot"
}

function bp
{
    export CDPATH=.:${DEV}/Patcher
    export P4CLIENT=jhudgins_patcher_${MACHINE}
    alias ic="icode Patcher"
    alias tag="mtags c:/dev/Patcher c:/dev/Patcher/Code c:/dev/Patcher/Riot"
}

function br
{
    export CDPATH=.:${DEV}/RiotClient
    export P4CLIENT=jhudgins_riot_client_${MACHINE}
    alias ic="icode KeystoneRiotClient"
    alias tag="mtags c:/dev/RiotClient c:/dev/RiotClient/Code c:/dev/RiotClient/Riot"
}

function bc
{
    export CDPATH=.:${DEV}/users
    export P4CLIENT=jhudgins_config_${MACHINE}
}

alias excel='/c/Program\ Files\ \(x86\)/Microsoft\ Office/Office12/EXCEL.EXE'
alias ls='ls -G'



# for i in `cat /c/work/find.txt`; do   if [[ `p4 fstat $i 2> /dev/null | grep "headType.*+w"` ]];              then echo $i;   fi ; done > /c/work/p4writable.txt
export PS1="\\[\\e]0;\\w\\a\\]\\n\\[\\e[33m\\]\\w\\[\\e[0m\\]\\n\\$ "
bf
