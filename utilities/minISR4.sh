#!/bin/bash

topics=$(kafkactl get topics -o json | jq -r '.[].name')

printf "%-40s %-10s %-10s %-10s\n" "TOPIC" "REPLICAS" "MIN_ISR" "ALERT"
printf "%s\n" "----------------------------------------------------------------------------------------"

for topic in $topics; do
    # Get replication factor
    rf=$(kafkactl describe topic "$topic" -o json | jq '.replicationFactor')

    # Get min.insync.replicas from topic config
    minISR=$(kafkactl describe topic-config "$topic" -o json | \
        jq -r '.[] | select(.name=="min.insync.replicas") | .value')

    # Skip if either is null/empty
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
