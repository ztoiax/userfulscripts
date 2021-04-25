# Useful scripts

## tmp script ,可避免因输错路径导致 rm -rf 的错误删除 `tmp.sh`

> similar `mv file /tmp`

- 如果 tmp 路径下已经存在该文件,则会在文件名后面加入日期

```bash
# useage
tmp.sh file
```

> 因为`/tmp` 是内存文件系统,系统会自动删除,可以减少 IO 的开销,代价是内存的减少,不适合大文件

> 因此建议使用[trash-cli](https://github.com/andreafrancia/trash-cli),类似于 windows 的回收站,只是把文件移动到一个目录里,并不会真正删除文件

## compress and decompress

**support type:**

- `7z`
- `gz`
- `bz2`
- `zip`
- `rar`
- `zip`
- `xz`
- `lz4`
- `zstd`

### fast pack and compress script `mytar.sh`

> Automatically determine the file extension name for compression
> Automatically switch pigz or gz,pbzip2 or bzip2

```bash
# show example:
mytar.sh

# view file contents
mytar.sh filename.zip
mytar.sh filename.xz
mytar.sh filename.lz4

# Compress a single file:
mytar.sh filename.zip file
mytar.sh filename.xz file
mytar.sh filename.7z file
mytar.sh filename.zst file

# tar and compress single or multiple directories:
mytar.sh filename.tar.gz /home /etc
mytar.sh filename.tar.xz /home /etc
mytar.sh filename.tar.lz4 /home /etc
mytar.sh filename.tar.zst /home /etc
```

**show compression ratio:**

- less than 100% is **green**
  ![image](./Pictures/ratio.png)

- greater than 100% is **red**
  ![image](./Pictures/ratio1.png)

**simple compression benchmark:**

```bash
mytar.sh test.tar.gz  /tmp/jianli /tmp/dwm
mytar.sh test.tar.bz2 /tmp/jianli /tmp/dwm
mytar.sh test.tar.xz  /tmp/jianli /tmp/dwm
mytar.sh test.7z      /tmp/jianli /tmp/dwm
```

- xz is slow but ratio is good

- 7z is fast and best

  ![image](./Pictures/benchmark.gif)

**Multithreading compression and decompression:**

- [pigz](https://github.com/madler/pigz)
- [bzip2](https://linux.die.net/man/1/pbzip2)
- [pixz](https://github.com/vasi/pixz)

  The above window shows the utilization useage of all CPU cores

  common gz compressing:
  ![image](./Pictures/pigz.gif)

  pigz compressing:
  ![image](./Pictures/pigz1.gif)

**More compress benchmark:**

- [Quick Benchmark: Gzip vs Bzip2 vs LZMA vs XZ vs LZ4 vs LZO](https://catchchallenger.first-world.info/wiki/Quick_Benchmark:_Gzip_vs_Bzip2_vs_LZMA_vs_XZ_vs_LZ4_vs_LZO)
- [Squash Compression Benchmark](https://quixdb.github.io/squash-benchmark/)

### decompress script `myx.sh`

```bash
# single file
myx.sh filename.tar.gz
myx.sh filename.7z

# decompress mutile file
myx.sh filename.7z filename.tar.gz
```

### top completion `mytop.sh`

![image](./Pictures/mytop.gif)

- [About parameter details and more benchmark](https://github.com/ztoiax/notes/blob/master/benchmark.md)

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

## 多线程ping

> 对 `ping -c 1 ip`进行多线程包装, 判断主机是否存在

```sh
# 指定ip
ip_thread 192.168.1.1 192.168.1.111

# 扫描端口: -n
ip_thread -n 192.168.1.1 192.168.1.111

# 指定文件内的ip
ip_thread.py $(cat ip_file)

# 指定网段
ip_thread 192.168.1.0/24 192.168.2.0/24
```

- 两者速度对比(我cpu是6核12线程)

```sh
for i in 192.168.1.{1..255}; do
    ping -c 1 $i
done
```

```sh
ip_thread.py 192.168.1.0/24
```

- 多线程到61, 而普通的shell命令才到9
![image](./Pictures/ipthread.gif)
