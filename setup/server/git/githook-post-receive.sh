#!/bin/sh
## arguments
# $1 is the name
# $2 is the opsworks stackid
# $3 is the opsworks appid
# hub git script

line0="Repository: $1"
line1=$(git show | head -n 1)
line2=$(git show | head -n 2 | tail -n 1)
#line3=$(git show | head -n 3 | tail -n 1)
line4=$(git show | head -n 5 | tail -n 1)
line5=$(git show | head -n 6 | tail -n 1)
curl -X POST 127.0.0.1:8080/hubot/git -d "msg=$line0"
curl -X POST 127.0.0.1:8080/hubot/git -d "msg=$line1"
curl -X POST 127.0.0.1:8080/hubot/git -d "msg=$line2"
#curl -X POST 127.0.0.1:8080/hubot/git -d "msg=$line3"
curl -X POST 127.0.0.1:8080/hubot/git -d "msg=Commit Message: $line4"
curl -X POST 127.0.0.1:8080/hubot/git -d "msg=$line5"

# opsworks deploy script
if [ -z $3 ]; then
  # exist if $2 && $3 not existing
  exit 1
fi

aws opsworks --region eu-central-1 create-deployment --stack-id $2 --app-id $3 --command "{\"Name\":\"deploy\"}"
curl -X POST 127.0.0.1:8080/hubot/git -d "msg=create deployment on stack: $2"
