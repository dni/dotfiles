#!/bin/sh
  command "apt-get install -y inspircd"
cookbook_file '/etc/inspircd/inspircd.conf' do
  source "irc/inspircd.conf"
cookbook_file '/etc/inspircd/inspircd.motd' do
  source "irc/inspircd.motd"
cookbook_file '/etc/inspircd/inspircd.rules' do
  source "irc/inspircd.rules"

service inspircd restart

# chat bot (hubot)
mkdir /opt/hubot
git clone git@git.hostinghelden.at:hubot.git /opt/hubot


