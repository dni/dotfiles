dotfiles
========
yeah yeah yeah
http://vüz.org/
dni's .dotfiles


# Docker FAQ
## Start Docker
boot2docker start -v
## Build new Webserver Image from Dockerfile
docker build -t server1 --no-cache .
## Start new Instance of the Webserver and launch Shell
docker run -it --name dnilabs -p 8000:80 server1 /bin/zsh
## exit from Shell
CRTL+P and CRTL-Q
## View running Instances
docker ps
## View all instances
docker ps -la
## Start a existing instance
docker start dnilabs
## Enter running Instance
docker attach dnilabs

