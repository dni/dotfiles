# aws

## EFS

### install
apt-get install nfs-common
pacman -S nfs-utils

### mount efs file storage
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \
fs-XXXXXXX.efs.eu-central-1.amazonaws.com:/ dir
