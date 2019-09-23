#!/bin/sh
# save server load only dump like this:
mysqldump --single-transaction --quick --lock-tables=false | gzip > db.gz
