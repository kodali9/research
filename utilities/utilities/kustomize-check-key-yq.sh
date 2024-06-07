#!/bin/bash

# Define variables
KUSTOMIZATION_FILE="kustomization.yaml"
CONFIGMAP_NAME="my-configmap"
NEW_KEY="your-key"
NEW_VALUE="your-value"

# Function to check if the key exists in the ConfigMap
function check_key_exists {
    existing_key=$(yq e ".configMapGenerator[] | select(.name == \"$CONFIGMAP_NAME\") | .literals[] | select(. == \"$NEW_KEY=$NEW_VALUE\")" $KUSTOMIZATION_FILE)

    if [ -n "$existing_key" ]; then
        return 0    # Key exists
    else
        return 1    # Key does not exist
    fi
}

# Function to update the key in the ConfigMap
function update_key {
    yq e -i "(.configMapGenerator[] | select(.name == \"$CONFIGMAP_NAME\") | .literals) |= map(select(. != \"$NEW_KEY=.*\")) + [\"$NEW_KEY=$NEW_VALUE\"]" $KUSTOMIZATION_FILE
}

# Function to add the key-value pair to the ConfigMap
function add_key {
    yq e -i ".configMapGenerator[] | select(.name == \"$CONFIGMAP_NAME\") | .literals += [\"$NEW_KEY=$NEW_VALUE\"]" $KUSTOMIZATION_FILE
}

# Override key if it exists or add it if it doesn't
if check_key_exists; then
    echo "Key exists, updating the value"
    update_key
else
    echo "Key does not exist, adding the key-value pair"
    add_key
fi
