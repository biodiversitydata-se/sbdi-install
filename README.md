# Monitoring

Monitoring and metrics using [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com).

The Grafana UI is available at https://monitoring.biodiversitydata.se.

To access the Prometheus UI you need to create an SSH tunnel and it will then be available at http://localhost:9090.

```
ssh -L 9090:127.0.0.1:9090 ubuntu@live-ext-1
```

## Instrumented services
The following services on the target machines export metrics:

Service | Exporter | Path
---|---|---
Linux | [node-exporter](https://github.com/prometheus/node_exporter) | :9100/metrics
Docker | [cAdvisor](https://github.com/google/cadvisor) | :9101/metrics

## Usage

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
