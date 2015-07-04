############################################################
# Dockerfile to run Memcached Containers
# Based on Ubuntu Image
############################################################

# Set the base image to use to Ubuntu
FROM ubuntu

# Set the file maintainer (your name - the file's author)
MAINTAINER dnilabs e.U

# Update the default application repository sources list
RUN apt-get update

# Install Memcached
RUN apt-get install memcached vim git

# Port to expose (default: 11211)
EXPOSE 11333

# Default Memcached run command arguments
CMD ["-m", "128"]

# Set the user to run Memcached daemon
USER daemon

# Set the entrypoint to memcached binary
ENTRYPOINT memcached
