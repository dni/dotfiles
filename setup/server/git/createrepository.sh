#!/bin/sh
dir=/home/git/
repo=$dir$1.git
mkdir $repo
cd $repo
git init --bare
chown -R git:git $repo
chmod -R 750 $repo
cat <<EOF > $repo/hooks/post-receive
#!/bin/sh
sh /home/git/githook-post-receive.sh $1
EOF
