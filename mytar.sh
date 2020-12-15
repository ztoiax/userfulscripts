#!/bin/bash

##### function ######
# check lanuage
if [ $LANG != zh_CN.UTF-8 ];then
    help(){
        echo -e "Automatically determine the file extension name for compression\n\nexample:" 
        echo -e "view file contents:
          mytar.sh filename.zip
          mytar.sh filename.xz\n"

        echo -e "Compress a single file:
          mytar.sh filename.zip file
          mytar.sh filename.xz file\n"

        echo -e "tar and compress single or multiple directories:
          mytar.sh filename.tar.gz /home /etc
          mytar.sh filename.tar.xz /home /etc\n"
    }
else
    help(){
        echo -e "自动确定压缩的文件扩展名\n\n例子：" 
        echo -e "查看压缩文件的内容：
          mytar.sh 文件名.zip
          mytar.sh 文件名.xz\n"

        echo -e "压缩单个文件：
          mytar.sh 文件名.zip 文件
          mytar.sh 文件名.xz 文件\n"

        echo -e "打包压缩单个或多个目录：
          mytar.sh 文件名.tar.gz /home /etc
          mytar.sh 文件名.tar.xz /home /etc\n"
    }
fi



# show compression ratio
checksize(){
    red='\033[0;31m'
    green='\033[0;32m'
    nc='\033[0m'

    if [ -f $2 ];then
        s=$(du -sb $2 | awk {'print $1'})
    else
        s=$2
    fi
    d=$(du -sb $1 | awk {'print $1'})

    # calc compression ratio
    # r=$(echo $d $s | awk '{printf "%.2f%\n",($1 / $2) * 100}')
    r=$(echo $d $s | awk '{printf "%d\n",($1 / $2) * 100}')
    if [ $r -ge 100 ];then
        echo -e "compression ratio: ${red}$r%${nc}"
    else
        echo -e "compression ratio: ${green}$r%${nc}"
    fi
}

# check pigz command
if which pigz &> /dev/null;then
    gz=pigz
    # targz="tar --use-compress-program=pigz -cvpf"
    targz="tar -I pigz -cvpf"
else
    gz=gzip
    targz="tar -zcpvf"
fi

if which pbzip2 &> /dev/null;then
    bz2=pbzip2
    tarbz2="tar -I pbzip2 -cvpf"
else
    bz2=bz2ip
    tarbz2="tar -jcpvf"
fi

if which pixz &> /dev/null;then
    xz="pixz -i"
    tarxz="tar -I pixz -cvpf"
else
    xz="xz -c"
    tarxz="tar -Jcvf"
fi

# check pv command
if which pv &> /dev/null;then
    gzpv(){
        $gz  -c $2 | pv > $1
    }
    bz2pv(){
        $bz2 -c $2 | pv > $1
    }
    xzpv(){
        $xz $2 | pv > $1
    }
    lz4pv(){
        lz4 -c $2 | pv > $1
    }
    zstdpv(){
        zstd -c $2 | pv > $1
    }
else
    gzpv(){
        $gz  -c $2 > $1
    }
    bz2pv(){
        $bz2 -c $2 > $1
    }
    xzpv(){
        $xz $2 > $1
    }
    lz4(){
        lz4  -c $2 > $1
    }
    zstdpv(){
        zstd -c $2 > $1
    }
fi

# view file contents
view-contents(){
    case $1 in
        *tar)  tar   -tvf $1;;
        *zip)  zcat  $1;;
        *gz)   zcat  $1;;
        *bz)   bzcat $1;;
        *bz2)  bzcat $1;;
        *xz)   xzcat $1;;
        *lz4)  lz4cat $1;;
        *zstd) zstdcat $1;;
        # 暂时获取不了内容
        *rar)  rar l $1;;
        *7z)   7z  l $1;;
        * )    echo "还没有收录$1的压缩格式"
    esac
}

# compression file or dir
compression(){
    case $1 in
        *.tar)      tar -cpvf $1 $2 && checksize $1 $3;;
        *.tar.gz)   $targz    $1 $2 && checksize $1 $3;;
        *.tar.bz)   $tarbz2   $1 $2 && checksize $1 $3;;
        *.tar.bz2)  $tarbz2   $1 $2 && checksize $1 $3;;
        *.tar.xz)   $tarxz    $1 $2 && checksize $1 $3;;
        *.tar.lz4)  tar -I lz4 -cf $1 $2 && checksize $1 $3;;
        *.tar.zst)  tar -I zstd -cf $1 $2 && checksize $1 $3;;
        *.tgz)      $targz    $1 $2 && checksize $1 $3;;
        *.tbz)      $tarbz2   $1 $2 && checksize $1 $3;;
        *.tbz2)     $tarbz2   $1 $2 && checksize $1 $3;;
        *.txz)      $tarxz    $1 $2 && checksize $1 $3;;
        *.tlz4)     tar -I lz4 -cf $1 $2 && checksize $1 $3;;
        *.tzst)     tar -I zstd -cf $1 $2 && checksize $1 $3;;
        # *.tar.7z)  tar -cpvf  ${1%.*} $2 && echo ${1%.*};echo $1&& 7z a $1 ${1%.*};;

        *.gz)   gzpv   $1 $2 && checksize $1 $2;;
        *.bz)   bz2pv  $1 $2 && checksize $1 $2;;
        *.bz2)  bz2pv  $1 $2 && checksize $1 $2;;
        *.xz)   xzpv   $1 $2 && checksize $1 $2;;
        *.lz4)  lz4pv  $1 $2 && checksize $1 $2;;
        *.zst)  zstdpv  $1 $2 && checksize $1 $2;;
        *.rar)  rar a  $1 $2 && checksize $1 $2;;
        *.zip)  zip -r $1 $2 && checksize $1 $2;;
        *.7z)   7z  a  $1 $2 && checksize $1 $3;;
        * ) echo "还没有收录$1的压缩格式"
    esac
}

##### main ######
case $# in
    0)  help;;

    1)  view-contents $1;;

    # 2)  compression $1 $2;;

    # 当变量大于2的时候，合并成一个变量$file
    *)
        # 备份$1
        bak=$1
        size=0
        shift
        for i in $@; do
            file="$file $i"
            # 计算目录的总大小
            size=$(expr $size + $(du -sb $i | awk {'print $1'}))
        done
        compression $bak "$file" $size
esac
