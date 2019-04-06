#!/bin/bash -x

##
## Do not run this every 30 minutes, you'll get a pileup
##

# Generate the list of all videos
cat ~/sarnobat.git/yurl_queue_httpcat.txt ~/sarnobat.git/db/yurl_flatfile_db/yurl_queue_2017.txt | grep -i -P '((xhamster)|(xvideos)|(pornhub\.com)|(dailymotion\.com)|(youtu\.be)|(youtube\.com)|(vimeo))' | grep -v '/playlist' | grep -v '/results' | grep -v '/user' | perl -pe 's{[0-9]+::[0-9]+::}{}g'  | perl -pe 's{[0-9]+::(.*)::[0-9]+}{$1}g' | tee ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos.txt > /dev/null

# Find out which videos have not been downloaded
# the list of downloaded videos gets generated by ________
touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt ;  comm -23 <(sort ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos.txt)  <(sort ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt) | grep -v channel | tac | tee /tmp/yurl_queue_httpcat_videos_undownloaded.txt >/dev/null
#cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos.txt | grep -v -f ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt | grep -v channel | tac | tee /tmp/yurl_queue_httpcat_videos_undownloaded.txt

# Download them, remove them from the input file, and record which have been downloaded in the output file
touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_failed.txt; chmod 777 ~/bin/youtube_download ; cd ~/github/httpcat && groovy download_video_from_list.groovy  /tmp/yurl_queue_httpcat_videos_undownloaded.txt /media/sarnobat/3TB/new/move_to_unsorted/videos/ ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_failed.txt 2> ~/download_video_from_list.log  | tee -a ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded_unreliable.txt 

# Find out which videos have not been downloaded (again - so we have accurate state that we can examine for debugging)
touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt ; cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos.txt | grep -v -f ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt | grep -v channel | tac | tee /tmp/yurl_queue_httpcat_videos_undownloaded.txt >/dev/null
