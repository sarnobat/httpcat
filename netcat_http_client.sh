
==== netcat simulate browser  ====

Mac OS X or Linux - send a request to not_now application

	echo "GET /not_now/items HTTP/1.1\r\nHost: netgear.rohidekar.com:4456\r\nOrigin: http://netgear.rohidekar.com\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36\r\nAccept: */*\r\nReferer: http://netgear.rohidekar.com/not_now?defaultPostponement=64&incrementAll=true\r\nConnection: keep-alive\r\nCache-Control: max-age=0\r\n\r\n" | nc netgear.rohidekar.com 4456

	# Do not indent
	cat <<EOF | perl -pe 's{\n}{\r\n}g' | nc netgear.rohidekar.com 4456
		GET /not_now/items HTTP/1.1
		Host: netgear.rohidekar.com:4456
		Origin: http://netgear.rohidekar.com
		Accept-Encoding: gzip, deflate, sdch
		Accept-Language: en-US,en;q=0.8
		User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36
		Accept: */*
		Referer: http://netgear.rohidekar.com/not_now?defaultPostponement=64&incrementAll=true
		Connection: keep-alive
		Cache-Control: max-age=0


	EOF

==== netcat simulate web server ====

Mac OS X - GNU macports version - very difficult

Mac OS X - preinstalled BSD version

	cat <<EOF | /usr/bin/nc -w 3  -l localhost 8500                                             /sarnobat.garagebandbroken/trash   
	HTTP/1.1 200 OK


	hi
	EOF

Linux:

	echo  "HTTP/1.1 200 OK\r\n\r\n $(date)" | nc -l 8500 

then open http://localhost:8500 in a browser

2017-01-16

