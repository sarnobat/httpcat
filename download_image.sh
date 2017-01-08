# !!!!!!!!!!!!!!!!!!! Handle duplicates in wget.sh
while read line
do
  echo "$line"
  cd /Unsorted/new/images/ && echo "$line" \
	| perl -pe 's{.*http}{http}g'  \
	| grep -P ".*(jpg|jpeg|png|gif)[?]?" \
	| xargs --delimiter '\n' --max-args=1 sh /home/sarnobat/github/httpcat/wget.sh 2>&1 \
	| tee -a ~/httpcat_download_image.log

#wget --content-disposition --directory-prefix=/Unsorted/new/images/   % 2>&1 | tee -a ~/httpcat_download_image.log
done < "${1:-/dev/stdin}"
