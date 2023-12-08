# Pipelines

The pipelines playbook sets up a cluster for running [pipelines](https://github.com/biodiversitydata-se/pipelines) to ingest data into the main search index used by the [biocache-service](https://github.com/biodiversitydata-se/biocache-service).

The following roles are used:
- java
- la-apt
- hadoop
- spark
- pipelines

To set up everything:
```
ansible-playbook -i inventories/prod pipelines.yml --ask-become-pass
```

To update pipelines configuration:
```
ansible-playbook -i inventories/prod pipelines.yml -t pipelines-config --ask-become-pass
```
