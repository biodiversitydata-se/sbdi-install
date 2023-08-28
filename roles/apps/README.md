# Apps

Deploy a single app (you will be prompted for app name and version):
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass -t deploy
```

Deploy a single app with name and version as parameters:
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass -t deploy --extra-vars "app_name=dashboard app_version=2.0.2"
```

Create app directories, deploy config files and deploy the the docker stack:
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass
```
