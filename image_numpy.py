#!/bin/python3
import numpy as np
import sys
from PIL import Image

image = []
image_np = []

if '-l' in sys.argv:
    five = True
    sys.argv.remove('-l')
else:
    five = False

for i in sys.argv[1:]:
    image.append(i)

for file in image:
    image_np.append(np.array(Image.open(file)))

# 合并
if five:
    # 最后一张图片总是0.5rgb
    n = 0.5
    image_merge = image_np[0] * n + image_np[1] * n

    for i in image_np[2:]:
        image_merge *= n
        image_merge += i * n
else:
    # 每张图片的rgb是平均的
    n = len(sys.argv) - 1.0
    n = abs(1.0 / n)

    image_merge = image_np[0] * n
    for i in image_np[1:]:
        image_merge += i * n

# 转换整数
image_merge = image_merge.astype(np.uint8)

Image.fromarray(image_merge).show()
