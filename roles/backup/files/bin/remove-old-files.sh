#!/bin/bash

KEEP_DAYS=95

echo "== Remove old files"

# Logs
echo "- logs: $(date)"
find /backup/log/nightly__*.log -type f -mtime +$KEEP_DAYS -exec rm {} \;

# Directories
echo "- directories: $(date)"
DIR_PATTERNS=(
    api/db_data_apiservice__*
    collectory/db_data_collectory__*
    image-service/db_data_image-service__*
    logger/db_data_logger__*
    spatial-service/db_data_spatial-service__*
    specieslists/db_data_specieslists__*
    wordpress_main/wordpress_main_db__*
    wordpress_docs/wordpress_docs_db__*
    wordpress_tools/wordpress_tools_db__*
    collectory/data_collectory__*
    wordpress_main/wordpress_main_html__*
    wordpress_docs/wordpress_docs_html__*
    wordpress_tools/wordpress_tools_html__*
    cas/mongodbcas-dump__*
    )
for DIR_PATTERN in "${DIR_PATTERNS[@]}"
do
    find /backup/data/$DIR_PATTERN -maxdepth 0 -type d -mtime +$KEEP_DAYS -exec rm -rf {} \;
done

# Files
echo "- files: $(date)"
FILE_PATTERNS=(
    apikey/apikey-dump__*.sql
    cas/emmet-dump__*.sql
    matomo/matomo-dump__*.sql
    )
for FILE_PATTERN in "${FILE_PATTERNS[@]}"
do
    find /backup/data/$FILE_PATTERN -type f -mtime +$KEEP_DAYS -exec rm {} \;
done

echo "- done: $(date)"
echo
