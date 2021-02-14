# Config
Files for environment on jhudgins machines.

## Setup:
* Install vim into c:/vim
* Install git bash
* Setup config files
```
mkdir -p c:/git
mkdir -p c:/work/backupdir
mkdir -p c:/work/temp
mkdir -p c:/work/undodir
git clone https://jhudgins@github.com/jahudgins/config c:/git/config
cp c:/git/config/win.sample.bashrc ~/.bashrc
cp c:/git/config/win.sample.vim_rc c:/vim/_vimrc
```
