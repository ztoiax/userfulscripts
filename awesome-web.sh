#!/bin/bash
# set -x
source ~/.mybin/variables-depend.sh

# simlar postman
hoppscotch(){
    cd $programs
    git clone https://github.com/hoppscotch/hoppscotch
    cd hoppscotch
    npm install
}

$install httpie # python 写的更友好的curl
