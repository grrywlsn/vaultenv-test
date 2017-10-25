# vaultenv-test
Vaultenv-test was created as a proof of concept in getting Vault secrets into
Kubernetes deployments using the new Vault Kubernetes backend.

No init-containers or sidecar injection are required; provided the Docker image
you wish to run has the vaultenv binary, it can work.

## requirements
- [Vaultenv](https://github.com/channable/vaultenv) in the container of your Kubernetes deployment
- [jq](https://stedolan.github.io/jq/) also in the container, but this could be swapped for some horrible shell parsing of JSON
- Vault 0.8.3 or greater, with Kubernetes auth backend enabled.

## vault setup
With Vault 0.8.3, `vault auth-enable kubernetes` will enable the Kubernetes backend if not done so already. You'll also need to set Vault to connect to Kubernetes API with `vault write auth/kubernetes/config`; check the Vault documentation for how that is configured.

You'll need to create a Vault role (`my-app`) which binds an existing Vault policy (`do-a-lot`) against the service account (`my-app-service-account`) in the namespace of your deployment (`default`):

    vault write auth/kubernetes/role/my-app
      bound_service_account_names=my-app-service-account \
      bound_service_account_namespaces=default \
      policies=do-a-lot \
      ttl=48h

For the purpose of this proof of concept, I created a test secret with

    vault write secret/helm-app/mytribe-sandbox/myapp \
      myappisworking=yesitsworking

## deploying to kubernetes

With Vault configured, I can deploy the Kubernetes yaml files included in `/kubernetes-example`

- rbac.yaml will create the service account `my-app-service-account` referenced in Vault, and give it auth-delegator access
- configmap.yaml will map the secrets in Vault to the environmental variables as they would appear to the Docker container - [see vaultenv docs](https://github.com/channable/vaultenv#secret-specification)
- deployment.yaml - more below

## configuring vaultenv from the deployment

A number of variables here might need to change for different deployments:  

- `serviceAccountName` matches the service account created by rbac.yaml
- because the service account is attached, `JSON_WEB_TOKEN` should get a valid JWT
- `VAULT_TOKEN` uses `jq`, and calls for the Vault role defined earlier (`my-app` in this case)
- the configmap is mounted as a volume, and then referenced by `secrets-file`
- VAULT_SERVICE_HOST and VAULT_SERVICE_PORT_VAULT were provided automatically by Kubernetes based on the service name and port of the Vault deployment. This may need to be adjusted for your own Vault installation.
- `no-connect-tls` is in place because it was a dev Vault; production Vault will need to be over HTTPS.
- `/usr/bin/printenv` is used as the application called by vaultenv; in reality the entrypoint of the Docker image should be here instead

When the deployment is made, the logs should show the curl commands and the content of printenv. If the secret is found, `ISWORKING=yesitsworking` should appear in the output.
