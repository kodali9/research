#!/bin/bash
set -e

# Config
JOB_ID=12345
DATABRICKS_TOKEN="your-databricks-token"
WORKSPACE_URL="https://<your-databricks-instance>"

# Start the job
run_response=$(curl -s -X POST "$WORKSPACE_URL/api/2.1/jobs/run-now" \
  -H "Authorization: Bearer $DATABRICKS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"job_id\": $JOB_ID}")

RUN_ID=$(echo "$run_response" | jq -r '.run_id')
echo "Triggered run ID: $RUN_ID"

# Poll for job completion
for i in {1..30}; do
  sleep 20
  response=$(curl -s -X GET "$WORKSPACE_URL/api/2.1/jobs/runs/get?run_id=$RUN_ID" \
    -H "Authorization: Bearer $DATABRICKS_TOKEN")

  state=$(echo "$response" | jq -r '.state.life_cycle_state')
  result_state=$(echo "$response" | jq -r '.state.result_state')

  echo "Job status: $state, result: $result_state"

  if [[ "$state" == "TERMINATED" ]]; then
    if [[ "$result_state" != "SUCCESS" ]]; then
      echo "Job failed in Databricks."
      exit 1
    fi

    # Read notebook output
    output=$(echo "$response" | jq -r '.notebook_output.result')
    echo "Notebook output (row count): $output"

    if [[ "$output" -gt 0 ]]; then
      echo "Query returned data — SUCCESS"
      exit 0
    else
      echo "Query returned no data — FAILURE"
      exit 1
    fi
  fi
done

echo "Timed out waiting for job to finish."
exit 1
