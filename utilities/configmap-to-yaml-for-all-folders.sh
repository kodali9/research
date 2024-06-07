#!/bin/bash

# Path to the main folder
main_folder="/path/to/your/main/folder"

# Python program to run
python_program="/path/to/your/python_program.py"

# Iterate over each subfolder in the main folder
for subfolder in "$main_folder"/*; do
    if [ -d "$subfolder" ]; then
        config_file="$subfolder/configmap.yaml"
        if [ -f "$config_file" ]; then
            echo "Found configmap.yaml in $subfolder. Running Python program."
            python3 "$python_program"
        else
            echo "No configmap.yaml found in $subfolder."
        fi
    fi
done
