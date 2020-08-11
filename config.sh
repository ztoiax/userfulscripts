#!/bin/bash
fishconfig() {
echo "正在配置fish"
myalias=\
'alias j "autojump"\n
alias c "clear"\n
alias s "screenfetch"\n
alias r "ranger"\n
alias vim "nvim"'
myexport=\
'export PATH="~/.mybin:$PATH" '
echo -e $myalias >> ~/.config/fish/config.fish
echo -e $export >> ~/.config/fish/config.fish

#autojump
echo "正在安装autojump.fish"
git clone https://github.com/wting/autojump.git
cd autojump
./install.py
echo "source ~/.autojump/share/autojump/autojump.fish" >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
}

nvimconfig(){
    if [ ! -d ~/.config/nvim ]; then
        mkdir ~/.config/nvim
    fi
echo "正在配置neovim"
config=\
'
syntax on
filetype plugin on
let g:mapleader = ","
set smartcase              "小写包含大写
set lazyredraw             "不要在宏和脚本执行期间更新屏幕。
set cursorlin              "突出显示当前在光标下的行。
set number                 "显示行号\n
set ignorecase             "不区分大小写\n
set list                   "开启空格字符\n
set path+=**               "find 子目录\n
set clipboard+=unnamedplus "直接复制剪切板
"分屏
noremap <Tab> :wincmd w <cr>
noremap <Leader>sm :only <cr>
noremap <Leader>sh :vsplit <cr>
noremap <Leader>sk :split <cr>
noremap <Leader>sl :belowright vsplit <cr>
noremap <Leader>sj :belo split <cr>
noremap <Leader>sq <C-w>c

" incert keymap like emacs
inoremap <C-w> <C-[>diwa
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k> <ESC>d$a
inoremap <C-u> <C-G>u<C-U>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-n> <Down>
inoremap <C-p> <Up>

noremap q :q <CR>
noremap Y y$
noremap j gj
noremap k gk
noremap  \  :%s//g<Left><Left>
vnoremap \  :s//g<Left><Left>
norema  <space> `
'
    cp ~/.config/nvim/init.vim{,.bak} && echo -e $config > ~/.config/nvim/init.vim
}

case $1 in
    fish* ) fishconfig;;
    nvim* ) nvimconfig;;
    * ) echo "$i还有收录";;
esac
