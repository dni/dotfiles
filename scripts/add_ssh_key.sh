#!/bin/bash
read -n 0 domain
cat ~/.ssh/id_rsa.pub | ssh root@$domain 'cat - >> ~/.ssh/authorized_keys'
