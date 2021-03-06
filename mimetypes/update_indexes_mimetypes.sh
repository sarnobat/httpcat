httpcat_urls=~/sarnobat.git/db/yurl_flatfile_db/auto/yurl_httpcat_urls.txt
httpcat_urls_sorted=/tmp/yurl_httpcat_urls_sorted.txt

httpcat_mimetypes=~/sarnobat.git/db/yurl_flatfile_db/auto/yurl_httpcat_urls_mimetyped.txt
httpcat_mimetypes_urls=/tmp/yurl_httpcat_mimetypes_urls.txt
httpcat_mimetypes_urls_sorted=/tmp/yurl_httpcat_mimetypes_urls_sorted.txt

httpcat_urls_not_mimetyped=/tmp/yurl_httpcat_mimetypes_missing.txt

touch "$httpcat_urls_sorted"
touch "$httpcat_mimetypes"
touch "$httpcat_mimetypes_urls"
touch "$httpcat_mimetypes_urls_sorted"


# Find out what urls we already have the mimetypes of
cat "$httpcat_mimetypes" | perl -pe 's{.*::\s*}{}g'  | grep http > "$httpcat_mimetypes_urls"


# Sort the all urls
sort "$httpcat_urls" > "$httpcat_urls_sorted"
echo `wc -l "$httpcat_urls_sorted"`" urls in total"

# Sort the urls for which we have mimetypes
sort "$httpcat_mimetypes_urls" > "$httpcat_mimetypes_urls_sorted"
echo `wc -l "$httpcat_mimetypes_urls_sorted"`" urls already with mimetypes"



cmd="comm -2 -3 \"$httpcat_urls_sorted\" \"$httpcat_mimetypes_urls\" > \"$httpcat_urls_not_mimetyped\""
echo "$cmd"
comm -2 -3 "$httpcat_urls_sorted" "$httpcat_mimetypes_urls_sorted" > "$httpcat_urls_not_mimetyped"

echo `wc -l "$httpcat_urls_not_mimetyped"`" not mimetyped" 

number_of_urls=60

cat "$httpcat_urls_not_mimetyped" \
	| grep http \
	| head -"$number_of_urls" \
	|  xargs --delimiter '\n' --max-args=1 sh ~/bin/httpcat_mimetype.sh \
	| tee -a ~/sarnobat.git/db/yurl_flatfile_db/auto/yurl_httpcat_urls_mimetyped.txt
	
2> echo "file updated: ~/sarnobat.git/db/yurl_flatfile_db/auto/yurl_httpcat_urls_mimetyped.txt"	