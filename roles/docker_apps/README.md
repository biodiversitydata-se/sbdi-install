# Docker apps

Deploy a single app (you will be promted for app name and version):
```
ansible-playbook -i inventories/prod playbooks/docker_apps.yml --ask-become-pass -t deploy
```

Deploy a single app with name and version as parameters:
```
ansible-playbook -i inventories/prod playbooks/docker_apps.yml --ask-become-pass -t deploy --extra-vars "app_name=dashboard app_version=2.0.2"
```

Create app directories, deploy config files and deploy the the docker image:
```
ansible-playbook -i inventories/prod playbooks/docker_apps.yml --ask-become-pass
```
