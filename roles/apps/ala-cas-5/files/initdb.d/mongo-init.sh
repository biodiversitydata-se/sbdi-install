#!/bin/sh
set -e

echo "Trying to create database and users"
if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && [ -n "${MONGO_INITDB_ROOT_PASSWORD:-}" ]; then
mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase $MONGO_INITDB_DATABASE<<EOF
db=db.getSiblingDB('cas-audit-repository');
db.createUser({
  user:  '$CAS_AUDIT_USERNAME',
  pwd: '$CAS_AUDIT_PASSWORD',
  roles: [{
    role: 'readWrite',
    db: 'cas-audit-repository'
  }]
});
db=db.getSiblingDB('cas-ticket-registry');
db.createUser({
  user:  '$CAS_TICKET_USERNAME',
  pwd: '$CAS_TICKET_PASSWORD',
  roles: [{
    role: 'readWrite',
    db: 'cas-ticket-registry'
  }]
});
db=db.getSiblingDB('cas-service-registry');
db.createUser({
  user:  '$CAS_SERVICE_USERNAME',
  pwd: '$CAS_SERVICE_PASSWORD',
  roles: [{
    role: 'readWrite',
    db: 'cas-service-registry'
  }]
});
EOF
else
    echo "Necessary credentials  missing, hence exiting database and user creation!"
    exit 403
fi