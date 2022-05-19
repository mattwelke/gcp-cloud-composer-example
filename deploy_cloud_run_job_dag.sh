#!/bin/bash

REGION=us-central1
SERVICE=cloud-run-job

# First, deploy Cloud Run service that does the work.
gcloud run deploy $SERVICE \
  --allow-unauthenticated \
  --port 8080 \
  --region $REGION \
  --source ./cloud_run_job

URL=$(gcloud run services describe $SERVICE \
  --format json \
  --region $REGION \
  | jq -r '.status.address.url')
echo "URL of Cloud Run service: $URL"

# Then, deploy DAG that calls the Cloud Run service via HTTP.
# Inject URL of Cloud Run service as config during DAG deploy.
cat cloud_run_job_dag.template.py \
  | sed "s,{{cloud_run_url}},$URL,g" \
  > cloud_run_job_dag.py

gcloud composer environments storage dags import \
  --environment my-environment --location $REGION \
  --source cloud_run_job_dag.py

echo "DAG deployed."
