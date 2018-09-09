# Config
Files for environment on jhudgins machines.

## Setup:
* Install vim into c:/vim
* Install cygwin
* Setup config files
```
mkdir -p c:/git
mkdir -p c:/work/backupdir
mkdir -p c:/work/undodir
git clone ssh://jhudgins@github.com/jahudgins/config c:/git/config
cp c:/git/config/vimrc.sample.windows c:/vim/_vimrc
cp c:/git/config/bashrc.sample.windows ~/.bashrc
```
