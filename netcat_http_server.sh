
# ==== netcat simulate web server ====

#Mac OS X - GNU macports version - very difficult

#Mac OS X - preinstalled BSD version

cat <<EOF | /usr/bin/nc -w 3  -l localhost 8500                                            
HTTP/1.1 200 OK


hi
EOF

# Linux:

echo  "HTTP/1.1 200 OK\r\n\r\n $(date)" | nc -l 8500 

#then open http://localhost:8500 in a browser


