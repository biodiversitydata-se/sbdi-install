Install observer services:
```
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t observer
```

Install target services:
```
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t target --ask-become-pass
```

Restart all observer services:
```
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t restart_observer
```

Restart individual observer services:
```
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t restart_prometheus
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t restart_grafana
```

Restart all target services:
```
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t restart_target --ask-become-pass
```

Restart individual target services:
```
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t restart_grafana --ask-become-pass
ansible-playbook -i inventories/prod playbooks/monitoring.yml -t restart_node_exporter --ask-become-pass
```
