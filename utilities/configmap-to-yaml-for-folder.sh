#!/bin/bash

# Check if folder argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <folder>"
  exit 1
fi

# Run the Python script with the provided folder
python3 convert_configmap.py "$1"
