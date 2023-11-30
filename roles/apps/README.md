# Apps

Update an existing app (only deploy docker-compose and restart stack). You will be prompted for app name and version:
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass -t deploy
```

Update an existing app (only deploy docker-compose and restart stack) with name and version as parameters:
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass -t deploy --extra-vars "app_name=dashboard app_version=2.0.2"
```

Full deploy - create app directories, deploy config files and deploy the docker stack:
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass
```

Full deploy - but do not start the service (doesn't work for all apps - check tags in main.yml for the app):
```
ansible-playbook -i inventories/prod playbooks/apps.yml --ask-become-pass --skip-tags deploy_service
```
