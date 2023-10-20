#!/bin/bash

# live-manager-1
/backup/bin/backup-docker_nfs-db.sh api db_data_apiservice
/backup/bin/backup-docker_nfs-db.sh collectory db_data_collectory
/backup/bin/backup-docker_nfs-db.sh image-service db_data_image-service
/backup/bin/backup-docker_nfs-db.sh logger db_data_logger
/backup/bin/backup-docker_nfs-db.sh spatial-service db_data_spatial-service
/backup/bin/backup-docker_nfs-db.sh specieslists db_data_specieslists
/backup/bin/backup-docker_nfs-db.sh wordpress_main wordpress_main_db
/backup/bin/backup-docker_nfs-db.sh wordpress_docs wordpress_docs_db
/backup/bin/backup-docker_nfs-db.sh wordpress_tools wordpress_tools_db
/backup/bin/backup-docker_nfs-dir.sh collectory data_collectory
/backup/bin/backup-docker_nfs-dir.sh wordpress_main wordpress_main_html
/backup/bin/backup-docker_nfs-dir.sh wordpress_docs wordpress_docs_html
/backup/bin/backup-docker_nfs-dir.sh wordpress_tools wordpress_tools_html

# live-ext-1
/backup/bin/backup-live-ext-1.sh

# live-molecular-1
/backup/bin/backup-live-molecular-1.sh

# Remove old backup files and logs
/backup/bin/remove-old-files.sh

# Print disk usage
echo "== Disk usage"
du -h --max-depth 1 /backup/data

echo
echo "== All done $(date)"
