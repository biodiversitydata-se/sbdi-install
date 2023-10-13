#!/bin/bash

APP=$1
DIR=$2
TODAY=$(date +%y%m%d)

echo "== $APP, docker_nfs dir: $DIR, date: $TODAY"

echo "- rsync: $(date)"
rsync -a live-manager-1:/docker_nfs/var/volumes/${DIR}/ /backup/data/$APP/${DIR}__${TODAY}
touch /backup/data/$APP/${DIR}__${TODAY}
echo "- done: $(date)"
echo
