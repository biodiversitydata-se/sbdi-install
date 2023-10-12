#!/bin/bash

APP=$1
DIR=$2
TODAY=`date +%y%m%d`

echo "== app: $APP, docker_nfs dir: $DIR, date: $TODAY"

echo "- copy to /data: `date`"
ssh live-manager-1 "sudo cp -a /docker_nfs/var/volumes/${DIR}/. /data/backup/nrm-sbdibackup/${DIR}/"
echo "- chmod: `date`"
ssh live-manager-1 "sudo chmod -R a+rx /data/backup/nrm-sbdibackup/${DIR}"
echo "- rsync: `date`"
rsync -a live-manager-1:/data/backup/nrm-sbdibackup/${DIR}/ /backup/data/$APP/${DIR}__${TODAY}
echo "- done: `date`"
echo
