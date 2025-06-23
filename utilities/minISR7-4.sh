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
    [[ "$rf" =~ ^[0-9]+$ ]] || rf=""

    # Extract min.insync.replicas safely
    minISR=$(echo "$desc" | jq -r '(.configs // [])[] | select(.name == "min.insync.replicas") | .value')
    [[ "$minISR" =~ ^[0-9]+$ ]] || minISR=""

    # Extract count of partitions with ISR=1
    isrCountOne=$(echo "$desc" | jq -r '[.partitions[]? | select((.isr | length) == 1)] | length')
    [[ "$isrCountOne" =~ ^[0-9]+$ ]] || isrCountOne=0

    # Flag if any ISR=1
    if [ "$isrCountOne" -gt 0 ]; then
        isrAlert="⚠️ YES"
    else
        isrAlert="no"
    fi

    # Flag if minISR >= replicationFactor
    if [ -n "$minISR" ] && [ -n "$rf" ] && [ "$minISR" -ge "$rf" ]; then
        configAlert="⚠️"
    else
        configAlert=""
    fi

    printf "%-40s %-10s %-10s %-15s %-10s\n" "$topic" "$rf" "$minISR" "$isrAlert" "$configAlert"
done
