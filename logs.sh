#!/bin/bash
# save pip,pkgs,npm number of package managers and agedu

notify-send 'logs.sh is running!' 'This is an record number of package managers.'

date=$(date +"%Y-%m-%d:%H:%M:%S")
dir="/home/tz/.logs"
path="$dir/$date-pkgs"

# pip
pipl=$(pip3 list)
pipn=$(echo "$pipl" | wc -l)
# npm
npml=$(npm list -g --depth=0 2> /dev/null)
npmn=$(echo "$npml" | wc -l)
# pkg
pl=$(pacman -Qs)
pn=$(echo "$pl" | wc -l )

echo "######pip#####" >> $path
echo "count:$pipn" >> $path
echo "$pipl" >> $path

echo "######npm#####" >> $path
echo "count:$npmn" >> $path
echo "$npml" >> $path

echo "######pkg#####" >> $path
echo "count:$pn" >> $path
echo "$pl" >> $path

# du
notify-send 'recording Usage of root directory.'
cd $dir
sudo agedu -s /
sudo chmod 775 agedu.dat
mv agedu.dat $date-agedu.dat
