#!/bin/zsh
sudo mount -t cifs //10.0.1.1/Data airport -o user=dnilabs,uid=1000,rw,sec=ntlm,vers=1.0
