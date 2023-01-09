

##
## Do not run this every 30 minutes, you'll get a pileup
##


YURL_QUEUE_2017="$HOME/db.git/yurl_flatfile_db/yurl_queue_2017.txt"
YURL_QUEUE_HTTPCAT="$HOME/db.git/yurl_queue_httpcat.txt"
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
JAVA="$JAVA_HOME/bin/java"
YURL_FILTER_VIDEOS="$HOME/bin/yurl_filter_videos.sh"
VIDEOS_DOWNLOAD_SUCCEEDED="$HOME/db.git/yurl_flatfile_db/videos_download_succeeded.txt"
FAILED="$HOME/db.git/auto/yurl_queue_httpcat_videos_failed.txt"
YURL_QUEUE_HTTPCAT_VIDEOS_FAILED="$HOME/db.git/auto/yurl_queue_httpcat_videos_failed.txt"
HTTPCAT="$HOME/github/httpcat"
YOUTUBE_DOWNLOAD="$HOME/bin/youtube_download.sh"



# Generate the list of all videos
cat "$YURL_QUEUE_2017"  "$YURL_QUEUE_HTTPCAT" | sh $YURL_FILTER_VIDEOS | grep -v '/playlist' | grep -v '/results' | grep -v '/user' | perl -pe 's{[0-9]+::[0-9]+::}{}g'  | perl -pe 's{[0-9]+::(.*)::[0-9]+}{$1}g' | tee /tmp/yurl_queue_httpcat_videos.txt > /dev/null
cat "$YURL_QUEUE_2017"  "$YURL_QUEUE_HTTPCAT" | grep -i -P '\.mp4' | perl -pe 's{[0-9]+::[0-9]+::}{}g'  | perl -pe 's{[0-9]+::(.*)::[0-9]+}{$1}g' | tee -a /tmp/yurl_queue_httpcat_videos.txt > /dev/null

update_tmp_files() {
	cat $VIDEOS_DOWNLOAD_SUCCEEDED   | grep '\.part' | perl -pe 's{::.*}{}g' | sh $YURL_FILTER_VIDEOS | uniq | sort | uniq > /tmp/yurl_queue_httpcat_videos_downloaded.txt
	touch /tmp/yurl_queue_httpcat_videos_downloaded.txt ;  comm -23 <(sort /tmp/yurl_queue_httpcat_videos.txt)  <(sort /tmp/yurl_queue_httpcat_videos_downloaded.txt) | grep -v channel | tac | tee /tmp/yurl_queue_httpcat_videos_undownloaded.txt >/dev/null
}

# Find out which videos have not been downloaded
# the list of downloaded videos gets generated by ________
update_tmp_files
#cat $HOME/db.git/auto/yurl_queue_httpcat_videos.txt | grep -v -f $HOME/db.git/auto/yurl_queue_httpcat_videos_downloaded.txt | grep -v channel | tac | tee /tmp/yurl_queue_httpcat_videos_undownloaded.txt

# TEMPORARILY REDUCE the number of videos downloaded, the server is getting overloaded.
cat /tmp/yurl_queue_httpcat_videos_undownloaded.txt | sort | uniq | shuf | head -${1:-2} | tee /tmp/yurl_queue_httpcat_videos_undownloaded_reduced.txt

cat /tmp/yurl_queue_httpcat_videos_undownloaded_reduced.txt



# Download them, remove them from the input file, and record which have been downloaded in the output file
# 3rd arg is redundant
touch "$FAILED"; chmod 777 "$YOUTUBE_DOWNLOAD" ; cd "$HTTPCAT" && cat /tmp/yurl_queue_httpcat_videos_undownloaded_reduced.txt | $JAVA -classpath $HOME/".groovy/lib/*:$HOME/.groovy/lib_java11/*" DownloadVideosFromList.java /tmp/yurl_queue_httpcat_videos_undownloaded_reduced.txt $HOME/videos/ /tmp/yurl_queue_httpcat_videos_downloaded.txt "$YURL_QUEUE_HTTPCAT_VIDEOS_FAILED" 2> /tmp/download_video_from_list.log  | tee -a /tmp/yurl_queue_httpcat_videos_downloaded_unreliable.txt 
#groovy download_video_from_list_v2.groovy  




#echo "[DEBUG] Finished downloading, updating list of downloaded videos."
# Hmmmmm, /tmp/yurl_queue_httpcat_videos_downloaded.txt is incomplete. Ignore what we generated earlier.

echo "[DEBUG] Updating list of undownloaded videos for next run."
#echo "[DEBUG] Finished"
## Find out which videos have not been downloaded (again - so we have accurate state that we can examine for debugging)
#touch /tmp/yurl_queue_httpcat_videos_downloaded.txt ; cat /tmp/yurl_queue_httpcat_videos.txt | grep -v -f /tmp/yurl_queue_httpcat_videos_downloaded.txt | grep -v channel | tac | tee /tmp/yurl_queue_httpcat_videos_undownloaded.txt >/dev/null

update_tmp_files

echo "[DEBUG] Finished updating list of undownloaded videos for next run."
