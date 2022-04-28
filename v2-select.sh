#!/bin/bash
dir=/etc/v2ray
file=$(ls $dir/v2 | fzf)
sudo cp $dir/v2/$file $dir/config.json
sudo systemctl restart v2ray.service
