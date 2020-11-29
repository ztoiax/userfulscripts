#!/bin/bash

aria2c --enable-rpc --rpc-listen-all &
node /home/tz/Downloads/Programs/webui-aria2/node-server.js &
