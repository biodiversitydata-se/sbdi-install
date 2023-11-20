#!/bin/bash

APP=$1
SERVICE_NAME=$2
DB_NAME=$3
TODAY=$(date +%y%m%d)

echo "== $APP, service: $SERVICE_NAME, db: $DB_NAME, date: $TODAY"

echo "- get host: $(date)"
HOST_AND_CONTAINER=$(/backup/bin/get-host-and-container.sh $SERVICE_NAME)
HOST_NAME="${HOST_AND_CONTAINER%:*}"
CONTAINER_ID="${HOST_AND_CONTAINER#*:}"

echo "- dump from $HOST_NAME $CONTAINER_ID: $(date)"
ssh $HOST_NAME 'touch .hushlogin'
ssh -T $HOST_NAME <<EOL
docker exec $CONTAINER_ID /bin/bash -c 'mysqldump -u root -p\$MYSQL_ROOT_PASSWORD $DB_NAME' > /tmp/$DB_NAME-dump.sql
EOL
ssh $HOST_NAME 'rm .hushlogin'

echo "- rsync: $(date)"
rsync -a $HOST_NAME:/tmp/$DB_NAME-dump.sql /backup/data/$APP/$DB_NAME-dump__${TODAY}.sql

echo "- done: $(date)"
echo
