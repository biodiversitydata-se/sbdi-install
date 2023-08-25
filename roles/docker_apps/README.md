# Docker apps

So far only deploys the Dashboard app.

Deploy the latest docker image:
```
ansible-playbook -i inventories/prod playbooks/docker_apps.yml -t deploy
```

Deploy a specfic docker image:
```
ansible-playbook -i inventories/prod playbooks/docker_apps.yml -t compose_file,deploy --ask-become-pass --extra-vars "app_version=2.0.2"
```

Create app directories, deploy config files and the latest Docker image:
```
ansible-playbook -i inventories/prod playbooks/docker_apps.yml --ask-become-pass
```
