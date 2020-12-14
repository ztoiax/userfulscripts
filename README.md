# Useful scripts

## tmp script ,可避免因输错路径导致 rm -rf 的错误删除 `tmp.sh`

similar `mv file /tmp`

- 如果 tmp 路径下已经存在该文件,则重命名文件

```bash
# useage
tmp file
```

## compress and decompress

**support type:**

- `7z`
- `gz`
- `bz2`
- `zip`
- `rar`
- `zip`
- `xz`

### fast pack and compress script `mytar.sh`

> Automatically determine the file extension name for compression

```bash
# show example:
mytar.sh

# view file contents
mytar.sh filename.zip
mytar.sh filename.xz

# Compress a single file:
mytar.sh filename.zip file
mytar.sh filename.xz file

# tar and compress single or multiple directories:
mytar.sh filename.tar.gz /home /etc
mytar.sh filename.tar.xz /home /etc
```

**show compression ratio:**

- less than 100% is **green**
  ![avatar](/Pictures/ratio.png)

- greater than 100% is **red**
  ![avatar](/Pictures/ratio1.png)

**simple compress benchmark:**

```bash
mytar.sh test.tar.gz  /tmp/jianli /tmp/dwm
mytar.sh test.tar.bz2 /tmp/jianli /tmp/dwm
mytar.sh test.tar.xz  /tmp/jianli /tmp/dwm
mytar.sh test.7z      /tmp/jianli /tmp/dwm
```

- xz is slow but ratio is good

- 7z is fast and best

  ![avatar](/Pictures/benchmark.gif)

### decompress script `myx.sh`

```bash
# single file
myx.sh filename.tar.gz
myx.sh filename.7z

# decompress mutile file
myx.sh filename.7z filename.tar.gz
```

### tech search engine

```bash
search iptable
#output
[1] Github
[2] IBM developer
[3] 华为技术支持
[4] Gitbook
[5] 阿里云社区
[6] archwiki
[7] 简书
[8] 夸克
[9] 华三技术支持
[10] 思科
[11] pkgs
[12] linux中国
[13] python pypi
输入0则全部打开，输入编号则打开的搜索引擎:
```
