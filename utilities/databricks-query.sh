#!/bin/bash
set -e

# Trigger the Databricks job via API
# Replace with your actual job ID and token
JOB_ID=12345
DATABRICKS_TOKEN="your-token"
WORKSPACE_URL="https://<your-databricks-instance>"

# Run job
run_response=$(curl -s -X POST "$WORKSPACE_URL/api/2.1/jobs/run-now" \
  -H "Authorization: Bearer $DATABRICKS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"job_id\": $JOB_ID}")

RUN_ID=$(echo "$run_response" | jq -r '.run_id')

# Poll status
for i in {1..30}; do
  sleep 20
  status=$(curl -s -X GET "$WORKSPACE_URL/api/2.1/jobs/runs/get?run_id=$RUN_ID" \
    -H "Authorization: Bearer $DATABRICKS_TOKEN" | jq -r '.state.life_cycle_state')
  
  result=$(curl -s -X GET "$WORKSPACE_URL/api/2.1/jobs/runs/get?run_id=$RUN_ID" \
    -H "Authorization: Bearer $DATABRICKS_TOKEN" | jq -r '.state.result_state')

  echo "Status: $status, Result: $result"

  if [[ "$status" == "TERMINATED" ]]; then
    if [[ "$result" != "SUCCESS" ]]; then
      echo "Databricks job failed."
      exit 1
    else
      echo "Databricks job succeeded."
      exit 0
    fi
  fi
done

echo "Job did not finish in time."
exit 1
