# !!!!!!!!!!!!!!!!!!! Handle duplicates in wget.sh
# TODO: This is not reliable enough, use groovy
while read line
do
  echo "$line"
  cd /3TB/new/move_to_unsorted/images/ && echo "$line" \
	| perl -pe 's{.*http}{http}g'  \
	| grep -P ".*(jpg|jpeg|png|gif)[?]?" \
	| xargs --delimiter '\n' --max-args=1 --no-run-if-empty sh /home/sarnobat/github/httpcat/wget.sh 2>&1 \
	| tee -a ~/httpcat_download_image.log

#wget --content-disposition --directory-prefix=/Unsorted/new/images/   % 2>&1 | tee -a ~/httpcat_download_image.log
done < "${1:-/dev/stdin}"
