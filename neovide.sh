#!/bin/sh

# 定义文件路径
SOCKET_FILE="/tmp/nvim.socket"

# 判断文件是否存在
if [ -e "$SOCKET_FILE" ]; then
    # 如果文件存在，直接执行neovide
    neovide
else
    # 如果文件不存在，执行neovide并指定--listen参数
    neovide -- --listen "$SOCKET_FILE"
fi
