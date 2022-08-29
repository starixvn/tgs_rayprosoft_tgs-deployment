#!/bin/bash
export PGPASSWORD='wXfrQBjK4XYFY3KH6D2D'
export PGHOST='db-production.cglu874fh5rb.ap-east-1.rds.amazonaws.com'
export PGPORT='5432'
export PGUSER='postgres'

pg_dump -w tgs  -f aws_tgs_full_backup_$(date +"%Y-%m-%d")

find aws_tgs_full_backup_* -type f -mtime +7 -exec rm -rf {} \;

# echo "0 0 * * * postgres /bin/sh /var/lib/postgresql/backup.sh > /dev/null 2>&1" >> /etc/crontab

