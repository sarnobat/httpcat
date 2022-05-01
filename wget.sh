## PRECONDITION
##   Do not call this script if the url was already fetched. We'll get huge numbers of duplicates

URL=$1
FILE_WITH_QUERY_PARAMS=`basename $1`
FILE_WITHOUT_QUERY_PARAMS=`echo $FILE_WITH_QUERY_PARAMS | perl -pe 's{\?.*}{}g'`
FILE=`groovy ~/bin/file_conflicting_avoid.groovy "$FILE_WITHOUT_QUERY_PARAMS"`

# !!!!!!!!!!!!!!! Handle duplicates`
# !!!!!!!! Even with ampersand at end, this hangs and prevents subsequent downloads.


#  FILE=`groovy ~/bin/url2file.groovy "$line"`
#  TARGET=`groovy ~/bin/file_conflicting_avoid.groovy "$FILE"`

# Seems like this is getting ignored.
#	--directory-prefix=/media/sarnobat/3TB/new/move_to_unsorted/images/ \
wget \
	--content-disposition \
	--no-check-certificate \
	--backups=10 \
	--output-document=$FILE \
	"$URL" \
	&& echo "$URL" | tee -a ~/sarnobat.git/httpcat_images_downloaded.txt

OUT="$PWD/$FILE"
ls "$OUT"* | xargs -n 1 -I% groovy ~/bin/file_exists_check.groovy  % "$1" ~/db.git/yurl_flatfile_db/images_download_succeeded.txt ~/db.git/yurl_flatfile_db/images_download_failed.txt 

#echo "$URL::$PWD/$FILE" | tee -a ~/db.git/yurl_flatfile_db/images_download_succeeded.txt
# do not redirect stderr to stdin. That is done only in the 
# cron task for the log file.
