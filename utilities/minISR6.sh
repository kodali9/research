#!/bin/bash

topics=$(kafkactl get topics -o json | jq -r '.[].name')

printf "%-40s %-10s %-10s %-10s\n" "TOPIC" "REPLICAS" "MIN_ISR" "ALERT"
printf "%s\n" "----------------------------------------------------------------------------------------"

for topic in $topics; do
    # Get topic description
    desc=$(kafkactl describe topic "$topic" -o json)

    # Extract replication factor
    rf=$(echo "$desc" | jq '.replicationFactor')

    # Extract min.insync.replicas from the configs array
    minISR=$(echo "$desc" | jq -r '.configs[] | select(.name == "min.insync.replicas") | .value')

    # Skip if any value is missing or invalid
    if [ -z "$rf" ] || [ -z "$minISR" ] || [ "$minISR" = "null" ]; then
        continue
    fi

    if [ "$minISR" -ge "$rf" ]; then
        alert="⚠️"
    else
        alert=""
    fi

    printf "%-40s %-10s %-10s %-10s\n" "$topic" "$rf" "$minISR" "$alert"
done
