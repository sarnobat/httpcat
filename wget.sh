URL=$1
FILE_WITH_QUERY_PARAMS=`basename $1`
FILE=`echo $FILE_WITH_QUERY_PARAMS | perl -pe 's{\?.*}{}g'`
wget \
	--directory-prefix=/Unsorted/new/images/ \
	--content-disposition \
	--no-check-certificate \
	--output-document=$FILE \
	"$URL" \
	| tee -a ~/sarnobat.git/httpcat_images_downloaded.txt &
# do not redirect stderr to stdin. That is done only in the 
# cron task for the log file.
