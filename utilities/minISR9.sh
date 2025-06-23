#!/bin/bash

topics=$(kafkactl get topics -o json | jq -r '.[].name')

printf "%-40s %-10s %-10s %-15s %-10s\n" "TOPIC" "REPLICAS" "MIN_ISR" "ISR=1?" "ALERT"
printf "%s\n" "----------------------------------------------------------------------------------------------"

for topic in $topics; do
    # Skip internal topics
    if [[ "$topic" == _* ]]; then
        continue
    fi

    # Get topic description
    desc=$(kafkactl describe topic "$topic" -o json)

    # Extract replication factor
    rf=$(echo "$desc" | jq -r '.replicationFactor')

    # Extract min.insync.replicas from the configs array
    minISR=$(echo "$desc" | jq -r '.configs[] | select(.name == "min.insync.replicas") | .value')

    # Validate that both values are integers
    if ! [[ "$rf" =~ ^[0-9]+$ ]]; then rf=""; fi
    if ! [[ "$minISR" =~ ^[0-9]+$ ]]; then minISR=""; fi

    # Determine if any partition has ISR count == 1
    isrCountOne=$(echo "$desc" | jq '[.partitions[] | select((.isr | length) == 1)] | length')

    if [ "$isrCountOne" -gt 0 ]; then
        isrAlert="⚠️ YES"
    else
        isrAlert="no"
    fi

    # Alert if minISR >= rf (only if both are valid)
    if [ -n "$minISR" ] && [ -n "$rf" ] && [ "$minISR" -ge "$rf" ]; then
        configAlert="⚠️"
    else
        configAlert=""
    fi

    printf "%-40s %-10s %-10s %-15s %-10s\n" "$topic" "$rf" "$minISR" "$isrAlert" "$configAlert"
done
