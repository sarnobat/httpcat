# Generate the list of all images
cat ~/sarnobat.git/yurl_queue_httpcat.txt | grep -i -P '(JPG|PNG|GIF)' | perl -pe 's{[0-9]+::[0-9]+::}{}g' | tee ~/sarnobat.git/db/auto/yurl_queue_httpcat_images.txt
# Find out which files have not been downloaded
touch ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt ; cat ~/sarnobat.git/db/auto/yurl_queue_httpcat_images.txt | grep -v -f ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt | tee ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_undownloaded.txt
# Download them, remove them from the input file, and record which have been downloaded in the output file
cd ~/github/httpcat && groovy download_file_from_list.groovy  ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_undownloaded.txt /media/sarnobat/3TB-ext4/new/move_to_unsorted/images ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded.txt | tee -a ~/sarnobat.git/db/auto/yurl_queue_httpcat_images_downloaded_unreliable.txt
