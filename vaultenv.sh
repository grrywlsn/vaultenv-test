JSON_WEB_TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
VAULT_TOKEN=`curl http://${VAULT_SERVICE_HOST}:${VAULT_SERVICE_PORT}/v1/auth/kubernetes/login -d '{ "jwt": "'"$JSON_WEB_TOKEN"'", "role": "demo" }'  | jq -r '.auth.client_token'`
echo "[INFO] Connecting to ${VAULT_SERVICE_HOST}:${VAULT_SERVICE_PORT_VAULT} with vault token ${VAULT_TOKEN}"

exec vaultenv \
   --host ${VAULT_SERVICE_HOST} \
   --port ${VAULT_SERVICE_PORT_VAULT} \
   --no-connect-tls \
   --token ${VAULT_TOKEN} \
   --secrets-file /secrets/secrets.file \
   /usr/bin/printenv
