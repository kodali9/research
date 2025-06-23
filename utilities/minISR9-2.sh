# Determine if any partition has ISR count == 1
isrCountOne=$(echo "$desc" | jq -r '[.partitions[] | select((.isr | length) == 1)] | length')

# Validate isrCountOne is an integer
if [[ "$isrCountOne" =~ ^[0-9]+$ ]] && [ "$isrCountOne" -gt 0 ]; then
    isrAlert="⚠️ YES"
else
    isrAlert="no"
fi
