#!/symotion-prefix)bin/bash
mynvimconfig(){
    #provider
    pip3 install pysdl2
    pip3 install pynvim
    pip3 install neovim-remote
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
