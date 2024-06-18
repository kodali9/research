#!/bin/bash

# List of services to check
services=("service1" "service2" "service3")

# Path to the directory containing service subfolders
services_dir="path/to/services"

# Python program to run
python_program="path/to/your_program.py"

# Iterate through each subfolder in the services directory
for service_folder in "$services_dir"/*; do
  # Get the basename of the service folder
  service_name=$(basename "$service_folder")

  # Check if the service name is in the list of services
  if [[ " ${services[@]} " =~ " ${service_name} " ]]; then
    # If the service is in the list, run the Python program
    echo "Running Python program for $service_name"
    python3 "$python_program" "$service_folder"
  fi
done
