#!/bin/sh
file=/home/git/$1.git/hooks/post-receive
rm -f $file
cat <<EOF > $file
#!/bin/sh
sh /home/git/githook-post-receive.sh $1 $2 $3
EOF
chown git $file
chmod +x $file
