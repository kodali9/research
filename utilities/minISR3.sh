#!/bin/bash

# Get all topics as JSON and extract names
topics=$(kafkactl get topics -o json | jq -r '.[].name')

printf "%-40s %-10s %-10s %-10s\n" "TOPIC" "REPLICAS" "MIN_ISR" "ALERT"
printf "%s\n" "----------------------------------------------------------------------------------------"

for topic in $topics; do
    # Describe topic
    output=$(kafkactl describe topic "$topic" -o json 2>/dev/null)

    # Skip if error or empty
    if [ -z "$output" ] || [ "$output" = "null" ]; then
        continue
    fi

    # Extract values
    replicas=$(echo "$output" | jq '.replicationFactor')
    minISR=$(echo "$output" | jq '.minInSyncReplicas')

    if [ "$minISR" -ge "$replicas" ]; then
        alert="⚠️"
    else
        alert=""
    fi

    printf "%-40s %-10s %-10s %-10s\n" "$topic" "$replicas" "$minISR" "$alert"
done
