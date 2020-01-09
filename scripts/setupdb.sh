#!/bin/sh
name=$1
pw=$2
mysql < <<EOF
create database $name default character set utf8 default collate utf8_general_ci;
create user $name identified by "$pw";
grant all privilegs on $name . * to $name;
EOF
