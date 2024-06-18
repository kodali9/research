#!/bin/bash

# List of services
SERVICES=("service1" "service2" "service3")

# Base directory where the services are located
BASE_DIR="/path/to/your/services"

# Iterate through each service in the list
for SERVICE in "${SERVICES[@]}"
do
  SERVICE_DIR="$BASE_DIR/$SERVICE"
  
  if [ -d "$SERVICE_DIR" ]; then
    CONFIGMAP_FILE="$SERVICE_DIR/configmap.yaml"
    
    if [ -f "$CONFIGMAP_FILE" ]; then
      # Change to the service directory
      cd "$SERVICE_DIR"
      
      # Run the kustomize edit add command
      kustomize edit add resource configmap.yaml
      
      echo "Processed $SERVICE_DIR"
    else
      echo "No configmap.yaml found in $SERVICE_DIR"
    fi
  else
    echo "$SERVICE_DIR does not exist"
  fi
done
