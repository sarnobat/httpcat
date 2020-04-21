#!/bin/bash

# Generate the list of all images
cat ~/sarnobat.git/yurl_queue_httpcat.txt | grep -i -P '(JPG|PNG|GIF)' | perl -pe 's{[0-9]+::[0-9]+::}{}g' | tee /tmp/yurl_queue_httpcat_images.txt 2>&1 >/dev/null

# Find out which files have not been downloaded
# grep -f crashes if the file is too large
#touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt ; cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_images.txt | nice grep -v -f ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt | tee ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_undownloaded.txt
touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt ; comm -2 -3  <(cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_images.txt | sort) <(cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt | perl -pe 's{::.*}{}g' | sort) | grep -v '^data:' | tee /tmp/yurl_queue_httpcat_images_undownloaded.txt 2>&1 >/dev/null

# Download them, remove them from the input file, and record which have been downloaded in the output file
cd ~/github/httpcat && groovy -DmaxFailures=5 -DmaxDownloads=10 download_file_from_list.groovy  /tmp/yurl_queue_httpcat_images_undownloaded.txt /media/sarnobat/3TB/new/move_to_unsorted/images ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt | tee -a /tmp/yurl_queue_httpcat_images_downloaded_unreliable.txt 2>&1 >/dev/null
