#!/bin/bash

# live-manager-1
/backup/bin/backup-swarm-mysql.sh collectory collectory_mysqldb-collectory collectory
/backup/bin/backup-swarm-pgsql.sh image-service image-service_pgsql-image-service images images
/backup/bin/backup-swarm-mysql.sh logger logger_mysqldb-logger logger
/backup/bin/backup-swarm-pgsql.sh spatial-service spatial-service_postgis-spatial-service layersdb layers
/backup/bin/backup-swarm-mysql.sh specieslists specieslist_mysqldb-specieslist-webapp specieslists
/backup/bin/backup-swarm-mysql.sh wordpress_main wordpress_mysqldb-wordpress-main wordpress
/backup/bin/backup-swarm-mysql.sh wordpress_docs wordpress_mysqldb-wordpress-docs wordpress
/backup/bin/backup-swarm-mysql.sh wordpress_tools wordpress_mysqldb-wordpress-tools wordpress

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
