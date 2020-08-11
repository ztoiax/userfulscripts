SCR="/tmp/ocr"

gnome-screenshot -a -f $SCR.png && mogrify -modulate 100,0 -resize 400% $SCR.png

tesseract $SCR.png $SCR &> /dev/null -l eng+chi1
cat $SCR.txt | sed 's/ //g' | xclip -selection clipboard

#需要删除换行请使用此语句 并注释上一句（行首加#）
#cat $SCR.txt | sed 's/ //g'| xargs | xclip -selection clipboard

#弹窗提示OCR结束 the code below Thanks to 陈留阳
# notify-send "OCR Done"

exit 0
