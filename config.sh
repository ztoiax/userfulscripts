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

alias sudo "sudo "
alias j    "autojump"
alias c    "clear"
alias r    "ranger"
alias cp   "cp -i"
alias rm   "rm -i"
alias grep "egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"

alias v        "nvim"
alias w        "watch -d -n 2"
alias ifconfig "ifconfig -a"
alias cplast   "history | tail -n 1 | cut -c8- | clip"

alias sl  "systemctl"
alias sls "systemctl status"
alias slr "systemctl restart"
alias sle="systemctl enbale"
alias sld="systemctl stop"
alias jl="journalctl"

alias pi "yum install -y"

# git
alias lg='lazygit'
alias gc='git clone'
alias ga='git add --all'
alias gm='git commit -m '
alias gp='git push'
alias gl='git log'
alias gb='git branch'
alias gs='git status'
# alias grhh "git reset --hard $(git log | awk 'NR  1{print $2}')"

# docker
alias dil   'sudo docker image ls'
alias dip   'sudo docker image pull'
alias dir   'sudo docker image rm'
alias dcl   'sudo docker container ls'
alias dcrun 'sudo docker container run'
alias dccp  'sudo docker container cp'
alias dck   'sudo docker container kill'
alias dcs   'sudo docker container stop'

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
set smartcase                "小写包含大写
set lazyredraw               "不要在宏和脚本执行期间更新屏幕。
set cursorline               "突出显示当前在光标下的行。
set number                   "显示行号
set norelativenumber         "相对行号
set cursorline               "突出显示当前在光标下的行。
set wrap                     "自动折行，即太长的行分成几行显示
set showmatch                "自动高亮对应的另一个圆括号、方括号和大括号。
set showcmd                  "显示输入key
set undofile                 "保留撤销历史。
set autochdir                "自动切换工作目录
set autoread                 "文件发生外部改变就会发出提示
set ignorecase               "不区分大小写
set list                     "开启空格字符
set listchars=tab:»·,trail:· "空格显示为·
set path+=**                 "find 子目录
set clipboard+=unnamedplus   "直接复制剪切板
set autoread                 "文件发生外部改变就会发出提示
"分屏
nmap <Tab> :wincmd w <cr>
nmap <Leader>sm :only <cr>
nmap <Leader>sh :vsplit <cr>
nmap <Leader>sk :split <cr>
nmap <Leader>sl :belowright vsplit <cr>
nmap <Leader>sj :belo split <cr>
nmap <Leader>sq <C-w>c

" incert keymap like emacs
imap <C-h> <BS>
imap <C-d> <Del>
imap <C-w> <C-[>diwa
imap <C-k> <Esc>lDa
imap <C-u> <Esc>d0xi
imap <C-y> <Esc>Pa

imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <Home>
imap <C-n> <Down>
imap <C-p> <Up>
imap <C-z> <ESC>ua
imap <C-o> <Esc>o
imap <C-s> <esc>:w<CR>
imap <C-q> <esc>:wq<CR>
imap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"

imap <leader>j <Esc>wi
imap <leader>k <Esc>bi

" command keymap like emacs
cmap <C-p> <Up>
cmap <C-k> <Up>
cmap <C-n> <Down>
cmap <C-j> <Down>
cmap <C-b> <Left>
cmap <C-f> <Right>
cmap <C-a> <Home>
cmap <C-e> <End>
cmap <C-d> <Del>
cmap <C-h> <BS>
cmap <C-t> <C-R>=expand("%:p:h") . "/" <CR>

tnoremap <A-[> <C-\><C-n>

nmap q :q <CR>
nmap Q q
nmap j gj
nmap k gk
nmap  \  :%s//g<Left><Left>
vnmap \  :s//g<Left><Left>
nmap  <space> `
nnmap ' "

nmap Y y$
nmap yu y0
nmap E v$h
nmap B vb
nmap <Leader>w :w<CR>
" Run the current line
nmap <leader>ee :execute getline(line('.'))<cr>
" Run the current line in sh
nmap <leader>el :execute '!'.getline('.')<cr>

nmap <Leader>u :<C-U><C-R>=printf("nohlsearch %s", "")<CR><CR>
" buffers
nmap <leader>1 :buffer1<cr>
nmap <leader>2 :buffer2<cr>
nmap <leader>3 :buffer3<cr>
nmap <leader>4 :buffer4<cr>
nmap <leader>5 :buffer5<cr>
nmap <leader>6 :buffer6<cr>
nmap <leader>7 :buffer7<cr>
nmap <leader>8 :buffer8<cr>
nmap <leader>9 :buffer9<cr>
nmap <leader>b :buffers<cr>
nmap <leader>n :bnext<cr>
nmap <leader>p :bprevious<cr>
nmap L         :bnext<cr>
nmap H         :bprevious<cr>
nmap <Leader>x :bw<cr>

" vmap
vmap ,' <esc>`>a'<esc>`<i'<esc>
vmap ," <esc>`>a"<esc>`<i"<esc>
vmap ,( <esc>`>a)<esc>`<i(<esc>
vmap ,[ <esc>`>a]<esc>`<i[<esc>
vmap ,<space> <esc>`>a<space><esc>`<i<space><esc>

vmap ,d <esc>`>a` <esc>`<i `<esc>
vmap ,c <esc>`>a<enter>```<esc>`<i```<enter><esc>kA
vmap ,i <esc>`>a*<esc>`<i*<esc>
vmap ,b <esc>`>a**<esc>`<i**<esc>
EOF
}

case $1 in
    fish* ) fishconfig;;
    nvim* ) nvimconfig;;
    * ) echo "$i还有收录";;
esac
