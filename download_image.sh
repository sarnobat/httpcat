# This is not reliable enough. Use groovy
while read line
do
  echo "$line"
  cd /Unsorted/new/images/ && echo "$line" | perl -pe 's{.*http}{http}g'  | grep ".*jpg[?]?" |  xargs -I% wget --content-disposition --directory-prefix=/Unsorted/new/images/   % 2>&1 | tee -a ~/httpcat_download_image.log
done < "${1:-/dev/stdin}"
