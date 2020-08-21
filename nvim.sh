#!/symotion-prefix)bin/bash
mynvimconfig(){
    #provider
    pip  install pysdl2
    pip  install pynvim
    pip  install neovim-remote
    pip  install pygments
    sudo cnpm install -g neovim
    #clip
    $install xclip
    #tag
    $install ctags
    $install global
    #coc
    curl -sL install-node.now.sh/lts | bash
    #neomake
    pip3 install pylint
    #neoformat
    pip3 install yapf
    #coc extension
    CocInstall coc-python
    CocInstall coc-tabnine
    CocInstall coc-git


    #last check other error
    checkhealth
}
