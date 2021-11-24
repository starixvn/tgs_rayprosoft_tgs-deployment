#!/bin/bash
for filename in $(aws rds describe-db-log-files --db-instance-identifier db-production | jq -r '.DescribeDBLogFiles[] | .LogFileName')
do
aws rds download-db-log-file-portion --db-instance-identifier db-production --output text --no-paginate --log-file $filename  >> /home/ubuntu/pg_logs/$filename
done

sudo find  /home/ubuntu/pg_logs/error/postgresql.log.* -type f -mtime +0 -exec rm -rf {} \;

sudo pgbadger /home/ubuntu/pg_logs/error/*  -o /var/www/html/pgbadger/log.html -f csvlog