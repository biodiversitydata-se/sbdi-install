# Playbooks

## Apps
[See apps role](../roles/apps/README.md)

## Solrcloud
Installs the solrcloud configset and creates the biocache collection. This playbook assumes the solrcloud app have been installed (using the apps playbook) and is running.

To install the configset and create the collection:
```
ansible-playbook -i inventories/prod playbooks/solrcloud.yml -t create
```

To remove the configset and the collection:
```
ansible-playbook -i inventories/prod playbooks/solrcloud.yml -t delete
```

## Monitoring
[See monitoring role](../roles/monitoring/README.md)

## Backup
[See backup role](../roles/backup/README.md)
