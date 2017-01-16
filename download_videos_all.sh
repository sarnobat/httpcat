# Generate the list of all videos
cat ~/sarnobat.git/yurl_queue_httpcat.txt | grep -i -P '((dailymotion\.com)|(youtu\.be)|(youtube\.com))' | grep -v '/playlist' | grep -v '/results' | grep -v '/user' | perl -pe 's{[0-9]+::[0-9]+::}{}g' | tee ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos.txt
# Find out which videos have not been downloaded
touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt ; cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos.txt | grep -v -f ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt | tee ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_undownloaded.txt
# Download them, remove them from the input file, and record which have been downloaded in the output file
chmod 777 ~/bin/youtube_download ; cd ~/github/httpcat && groovy download_video_from_list.groovy  ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_undownloaded.txt /media/sarnobat/3TB-ext4/new/move_to_unsorted/videos/ ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded.txt | tee -a ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_downloaded_unreliable.txt
