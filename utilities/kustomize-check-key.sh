#!/bin/bash

# Define variables
CONFIGMAP_NAME="my-configmap"
NEW_KEY="your-key"
NEW_VALUE="your-value"

# Function to extract the existing ConfigMap and check if the key exists
function check_key_exists {
    existing_keys=$(kustomize edit list configmap $CONFIGMAP_NAME | grep "^[ ]*$NEW_KEY[ ]*:")

    if [ -n "$existing_keys" ];            # If the key exists, it will not be empty
    then
        return 0                           # Key exists
    else
        return 1                           # Key does not exist
    fi
}

# Override key if it exists or add it if it doesn't
if check_key_exists; then
    echo "Key exists, updating the value"
    kustomize edit set configmap $CONFIGMAP_NAME --from-literal=$NEW_KEY=$NEW_VALUE
else
    echo "Key does not exist, adding the key-value pair"
    kustomize edit add configmap $CONFIGMAP_NAME --from-literal=$NEW_KEY=$NEW_VALUE
fi
