# SBDI Install

Ansible playbooks for installing and updating the main applications of the SBDI system as well as some supporting services.

## Playbooks

### Apps
[See apps role](roles/apps/README.md)

### Pipelines
[See pipelines role](roles/pipelines/README.md)

### Solrcloud
Installs the solrcloud configset and creates the biocache collection. This playbook assumes the solrcloud app have been installed (using the apps playbook) and is running.

To install the configset and create the collection:
```
ansible-playbook -i inventories/prod solrcloud.yml -t create
```

To remove the configset and the collection:
```
ansible-playbook -i inventories/prod solrcloud.yml -t delete
```

### Monitoring
[See monitoring role](roles/monitoring/README.md)

### Backup
[See backup role](roles/backup/README.md)

## Ansible vault and secrets
Ansible vault is used to encrypt secrets in the files. To supply the password for ansible vault the system expects an executable file ```~/.bin/ansible-vault-pass.sh```
with the following content:

```
#!/bin/sh
pass show ansible-vault-password
```

To setup [pass](https://www.passwordstore.org/):

- Install pass: ```sudo apt-get install pass```
- You need a personal GPG key. If you do not have one generate one with: ```gpg --gen-key```
- Create a password store with: ```pass init "...your email from your GPG key"```
- Add the ansible-vault-password to the password store with: ```pass insert ansible-vault-password```

To view an encypted file:
```
ansible-vault view group_vars/all/vault.yml 
```

To edit an encypted file:
```
EDITOR=nano ansible-vault edit group_vars/all/vault.yml
```

## Utility scripts
There are also some utility scripts in the [utils](utils) folder.
