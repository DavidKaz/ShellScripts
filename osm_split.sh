#!/usr/bin/env bash
# split image into tiles for use as openstreetmap layer

set -e

IMAGE_FILE=$1
printf "splitting image %s\n" "$IMAGE_FILE"

EXT="${IMAGE_FILE##*.}"
printf "image extension is %s\n" "$EXT"

CH=$2
CW=$3

W=$(identify -format "%[fx:w]" "$IMAGE_FILE")
printf "image width %s\n" "$W"

H=$(identify -format "%[fx:h]" "$IMAGE_FILE")
printf "image height %s\n" "$H"

NW=$((W / CW))
RW=$((W % CW))
if [ $RW -ne 0 ]; then
  NW=$((NW + 1))
fi
printf "columns count is %s\n" "$NW"

NH=$((H / CH))
RH=$((H % CH))
if [ $RH -ne 0 ]; then
  NH=$((NH + 1))
fi
printf "rows count is %s\n" "$NH"

COUNT=$((NW * NH))
printf "overall count is %s\n" "$COUNT"

COUNT_DIGITS="${#COUNT}"
echo $COUNT_DIGITS

convert "$IMAGE_FILE" -crop "${CH}x${CW}" "image-%0${COUNT_DIGITS}d.$EXT"

mkdir output
k=0
for (( i=0; i<NW; i++ ))
do
  for (( j=0; j<NH; j++ ))
  do
    mkdir -p output/$j
    printf "%0${COUNT_DIGITS}d\n" $k
    mv "image-$(printf "%0${COUNT_DIGITS}d.$EXT" $k)" "output/$j/$i.$EXT"
    k=$((k + 1))
  done
done
