# !!!!!!!!!!!!!!!!!!! Handle duplicates in wget.sh
# TODO: This is not reliable enough, use groovy
# TODO: doesn't work on:
# 	https://img-estaticos.atleticodemadrid.com/system/fotos/6775/destacado_920x920/25_werner.png?1500976961
while read line
do
  echo "$line"
#  FILE=`groovy ~/bin/url2file.groovy "$line"`
#  TARGET=`groovy ~/bin/file_conflicting_avoid.groovy "$FILE"`
  cd ${1:-/media/sarnobat/3TB/disks/bisque/new/unsorted/images} &&  echo "$line" \
	| perl -pe 's{.*http}{http}g'  \
	| grep -P ".*(jpg|jpeg|png|gif|gifv)[?]?" \
	| xargs --delimiter '\n' --max-args=1 --no-run-if-empty sh ~/github/httpcat/wget.sh ~/bin/file_exists_check.groovy  2>&1 \
	| tee -a ~/httpcat_download_image.log

  readlink -f $TARGET | tee ~/sarnobat.git/db/yurl_flatfile_db/images_download_succeeded.txt

#wget --content-disposition --directory-prefix=/Unsorted/new/images/   % 2>&1 | tee -a ~/httpcat_download_image.log
done < "${1:-/dev/stdin}"
