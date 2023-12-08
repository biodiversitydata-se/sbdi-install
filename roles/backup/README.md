# Backup

The backup playbook is used to set up a backup server. The backup server is used to take and store backups from the SBDI servers.

The backup playbook will do the following:
- Create a user (sbdi) with an ssh key and ssh config. The public ssh key will need to manually be copied to the servers listed in [ssh_config](files/ssh_config).
- A directory structure in `/backup` (that directory is expected to already be present)
- Copy backup scripts
- Add a crontab entry for the user sbdi that will run nightly backups

Set up backup server:
```
ansible-playbook -i inventories/prod backup.yml --ask-become-pass
```

Only copy backup scripts (bin folder) to server:
```
ansible-playbook -i inventories/prod backup.yml -t scripts --ask-become-pass
```

## Nightly backups
A cronjob will run the [nightly.sh](files/bin/nightly.sh) script to backup databases and files from the SBDI servers. Backups are stored, per application, in the `/backup/data` directory. Each file or directory is date-stamped so a new set of backup files is created every night. Old backups will however automatically be removed after a specific number of days (currently 95). Logs for the nightly job can be found in `/backup/log`.

## Manual backups
Less frequently changing data can be backed up manually. See [manual-backups.txt](files/manual-backups.txt) for a list of commands to run. 