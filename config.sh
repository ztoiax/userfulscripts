#!/bin/bash
fishconfig() {
if [ ! -f ~/.config/fish/config.fish ]; then
    mv ~/.config/fish/config.fish{,.bak}
fi
#autojump
echo "正在安装autojump.fish"
git clone https://github.com/wting/autojump.git
cd autojump
./install.py

echo "正在配置fish"
cat > ~/.config/fish/config.fish << 'EOF'
alias j "autojump"
alias c "clear"
alias r "ranger"
alias rm "rm -i"

alias w="watch -d -n 2"
alias ifconfig="ifconfig -a"
alias cplast="history | tail -n 1 | cut -c8- | clip"

set -x nvim ~/.config/nvim/init.vim
set -x fish ~/.config/fish/config.fish

export PATH="/root/.mybin:$PATH"
source ~/.autojump/share/autojump/autojump.fish

EOF

source ~/.config/fish/config.fish
}

nvimconfig(){
    if [ ! -d ~/.config/nvim ]; then
        mkdir ~/.config/nvim
    else
        datetime=$(date +%D)
        mv ~/.config/nvim{,.$datetime}
        mkdir ~/.config/nvim
    fi
    if [ vim --version | grep '\-clipboard' ];then
        yum install -y vim-X11
    fi

echo "正在配置neovim"
cat > ~/.config/nvim/init.vim << 'EOF'
syntax on
filetype plugin on
let g:mapleader = ","
set smartcase              "小写包含大写
set lazyredraw             "不要在宏和脚本执行期间更新屏幕。
set cursorline             "突出显示当前在光标下的行。
set number                 "显示行号
set norelativenumber       "相对行号
set cursorline             "突出显示当前在光标下的行。
set wrap                   "自动折行，即太长的行分成几行显示
set showmatch              "自动高亮对应的另一个圆括号、方括号和大括号。
set showcmd                "显示输入key
set undofile               "保留撤销历史。
set autochdir              "自动切换工作目录
set autoread               "文件发生外部改变就会发出提示
set ignorecase             "不区分大小写
set list                   "开启空格字符
set listchars=tab:»·,trail:· "空格显示为·
set path+=**               "find 子目录
set clipboard+=unnamedplus "直接复制剪切板
set autoread               "文件发生外部改变就会发出提示
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
nnoremap Q q
noremap Y y$
noremap j gj
noremap k gk
noremap  \  :%s//g<Left><Left>
vnoremap \  :s//g<Left><Left>
noremap  <space> `
nnoremap ' "

nmap Y y$
nmap E v$
nmap <Leader>w :w<CR>
" Run the current line
nnoremap <leader>ee :execute getline(line('.'))<cr>
" Run the current line in sh
nnoremap <leader>el :execute '!'.getline('.')<cr>

noremap <leader>n :bnext
noremap <leader>p :bprevious
nmap <Leader>u  :<C-U><C-R>=printf("nohlsearch %s", "")<CR><CR>
EOF
}

case $1 in
    fish* ) fishconfig;;
    nvim* ) nvimconfig;;
    * ) echo "$i还有收录";;
esac
