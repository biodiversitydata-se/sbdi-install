#!/bin/bash

SERVICE_NAME=$1

ssh live-manager-1 'touch .hushlogin'

ssh -T live-manager-1 <<EOL
TASK_ID=\$(docker service ps --filter 'desired-state=running' $SERVICE_NAME -q)
NODE_ID=\$(docker inspect --format '{{ .NodeID }}' \$TASK_ID)
CONTAINER_ID=\$(docker inspect --format '{{ .Status.ContainerStatus.ContainerID }}' \$TASK_ID)
NODE_HOST=\$(docker node inspect --format '{{ .Description.Hostname }}' \$NODE_ID)
echo "\$NODE_HOST:\$CONTAINER_ID"
EOL

ssh live-manager-1 'rm .hushlogin'
