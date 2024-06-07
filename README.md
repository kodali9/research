# yq - delete a vslue
yq -i 'del(.resources[] | select(. == "configmap.yaml"))' kustomization.yaml
