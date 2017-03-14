URL=$1
FILE_WITH_QUERY_PARAMS=`basename $1`
FILE=`echo $FILE_WITH_QUERY_PARAMS | perl -pe 's{\?.*}{}g'
# !!!!!!!!!!!!!!! Handle duplicates`
# !!!!!!!! Even with ampersand at end, this hangs and prevents subsequent downloads.
wget \
	--directory-prefix=/media/sarnobat/3TB/new/move_to_unsorted/images/ \
	--content-disposition \
	--no-check-certificate \
	--backups=10 \
	--output-document=$FILE \
	"$URL" \
	&& echo "$URL" | tee -a ~/sarnobat.git/httpcat_images_downloaded.txt \
# do not redirect stderr to stdin. That is done only in the 
# cron task for the log file.
