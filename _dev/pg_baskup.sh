#!/bin/bash
export PGPASSWORD='abcd1234'
export PGHOST='192.168.50.125'
export PGPORT='5432'
export PGUSER='rpdev'
pg_dump -w tgs  -f dev_tgs_full_backup_$(date +"%Y-%m-%d")

find dev_tgs_full_backup_* -type f -mtime +7 -exec rm -rf {} \;




## echo "0 0 * * * root /bin/sh /home/ubuntu/pg_backup.sh > /dev/null 2>&1" >> /etc/crontab