#!/bin/bash

TODAY=$(date +%y%m%d)

ssh live-ext-1 'touch .hushlogin'

echo "== apikey, date: $TODAY"
echo "- dump: $(date)"
ssh -T live-ext-1 <<'EOL'
docker exec apikey-mysqldb /bin/bash -c 'mysqldump -u root -p$MYSQL_ROOT_PASSWORD apikey' > /tmp/apikey-dump.sql
EOL
echo "- rsync: $(date)"
rsync -a live-ext-1:/tmp/apikey-dump.sql /backup/data/apikey/apikey-dump__${TODAY}.sql
echo "- done: $(date)"
echo

echo "== cas, date: $TODAY"
echo "- dump: $(date)"
ssh -T live-ext-1 <<'EOL'
docker exec ala-cas-5-mysqldb /bin/bash -c 'mysqldump -u root -p$MYSQL_ROOT_PASSWORD emmet' > /tmp/emmet-dump.sql
EOL
echo "- rsync: $(date)"
rsync -a live-ext-1:/tmp/emmet-dump.sql /backup/data/cas/emmet-dump__${TODAY}.sql
echo "- done: $(date)"
echo

echo "== matomo, date: $TODAY"
echo "- dump: $(date)"
ssh -T live-ext-1 <<'EOL'
docker exec matomo-docker_matomo_db_1 /bin/bash -c 'mysqldump -u root -p$MYSQL_ROOT_PASSWORD matomo' > /tmp/matomo-dump.sql
EOL
echo "- rsync: $(date)"
rsync -a live-ext-1:/tmp/matomo-dump.sql /backup/data/matomo/matomo-dump__${TODAY}.sql
echo "- done: $(date)"
echo

echo "== mongodbcas, date: $TODAY"
echo "- dump: $(date)"
ssh -T live-ext-1 <<'EOL'
docker exec ala-cas-5-mongodb /bin/bash -c 'mongodump -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase=$MONGO_INITDB_DATABASE --out=/tmp/mongodbcas_dump'
docker cp ala-cas-5-mongodb:/tmp/mongodbcas_dump /tmp
EOL
echo "- rsync: $(date)"
rsync -a live-ext-1:/tmp/mongodbcas_dump/ /backup/data/cas/mongodbcas-dump__${TODAY}
touch /backup/data/cas/mongodbcas-dump__${TODAY}
echo "- done: $(date)"
echo

ssh live-ext-1 'rm .hushlogin'
