
cat <<EOF
For Graal VM compilation, see: 
bat graal-native-image/run.sh
EOF

## 2022-07-29



## Work


## Air
cat <<EOF
/usr/local/Cellar/openjdk@11/11.0.12/bin/java -classpath "$HOME/github/groovy_libraries/.groovy/lib/*" ~/github/httpcat/HttpcatPure.java 4466 2>&1 | tee  /tmp/out.log | grep  --line-buffered http | xargs -n 1 -d'\n' open
EOF