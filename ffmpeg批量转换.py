#!/bin/python
import ffmpeg
import os

flist = []
# 拓展名
video_suffix = ['.MP4', '.avi', '.mkv', '.mp4', '.webm']

# 递归所有子目录
for root, dirs, files in os.walk("/mnt/E/迅雷下载", topdown=False):
    for name in files:
        if os.path.splitext(name)[1] in video_suffix:
            info = ffmpeg.probe(os.path.join(root, name))
            try:
                v_bitrate = int(info['format']['bit_rate'])
            except BaseException:
                v_bitrate = 0
            try:
                a_bitrate = int(info['streams'][1]['bit_rate'])
            except BaseException:
                a_bitrate = 0

            flist.append({'name': os.path.join(root, name),
                         'v_bitrate': v_bitrate, 'a_bitrate': a_bitrate})

# 对视频码率排序
print(sorted(flist, key=lambda x: x['v_bitrate']))
# 对音频码率排序
print(sorted(flist, key=lambda x: x['a_bitrate']))
