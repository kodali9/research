isrCountOne=$(echo "$desc" | jq -r '[.partitions[]? | select(.isr != null and (.isr | length == 1))] | length')
