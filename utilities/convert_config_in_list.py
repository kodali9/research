#!/bin/bash

# Check if the environment directory and subfolders list are provided
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <environment_directory> <subfolder1> [<subfolder2> ... <subfolderN>]"
  exit 1
fi

# Environment directory to process
ENV_DIR="$1"
shift

# List of subfolders to check
SUBFOLDERS=("$@")

# Base directory for environments
BASE_DIR="/path/to/your/gitlab/project/environments"

# Check if the provided environment directory exists within the base directory
if [ ! -d "$BASE_DIR/$ENV_DIR" ]; then
  echo "Environment directory $BASE_DIR/$ENV_DIR does not exist."
  exit 1
fi

# Full path to the environment directory
ENV_DIR_PATH="$BASE_DIR/$ENV_DIR"

# Python script to run
PYTHON_SCRIPT="/path/to/your/script.py"

echo "Processing environment: $ENV_DIR_PATH"

# Loop through each specified subfolder within the environment
for SUBFOLDER in "${SUBFOLDERS[@]}"; do
  SERVICE_DIR="$ENV_DIR_PATH/$SUBFOLDER"
  
  if [ -d "$SERVICE_DIR" ]; then
    echo "  Checking service: $SERVICE_DIR"

    # Check for the existence of configmap.yaml
    if [ -f "$SERVICE_DIR/configmap.yaml" ]; then
      echo "    Found configmap.yaml in $SERVICE_DIR"

      # Change to the service directory and run the Python script
      cd "$SERVICE_DIR" || continue
      python3 "$PYTHON_SCRIPT"
    else
      echo "    No configmap.yaml found in $SERVICE_DIR"
    fi
  else
    echo "  Service directory $SERVICE_DIR does not exist."
  fi
done

echo "Done!"
