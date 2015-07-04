############################################################
# Dockerfile to run Memcached Containers
# Based on Ubuntu Image
############################################################

FROM ubuntu
MAINTAINER dnilabs e.U

RUN apt-get install -y git
RUN git clone https://github.com/dni/dotfiles
RUN . dotfiles/.install_webserver
