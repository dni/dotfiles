############################################################
# Dockerfile to run Memcached Containers
# Based on Ubuntu Image
############################################################

FROM ubuntu
MAINTAINER dnilabs e.U

# -y to not ask (y/n)
RUN apt-get install -y git
# recursive for submodule (vim)
RUN git clone --recursive https://github.com/dni/dotfiles

RUN . dotfiles/.install_webserver

EXPOSE 80
