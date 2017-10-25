#!/bin/bash
JSON_WEB_TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
VAULT_TOKEN=`curl http://${VAULT_SERVICE_HOST}:${VAULT_SERVICE_PORT}/v1/auth/kubernetes/login -d '{ "jwt": "'"$JSON_WEB_TOKEN"'", "role": "my-app" }'  | jq -r '.auth.client_token'`
exec vaultenv \
     --host ${VAULT_SERVICE_HOST} \
     --port ${VAULT_SERVICE_PORT_VAULT} \
     --no-connect-tls \
     --no-inherit-env \
     --token ${VAULT_TOKEN} \
     --secrets-file /secrets/secrets.file \
     /usr/bin/printenv >> /etc/env-variables/secrets
