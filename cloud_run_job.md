# cloud_run_job

Prereqs:

- gcloud
- jq
- GCP project created
- Cloud Composer API enabled
- Artifact Registry API enabled
- Cloud Run API enabled


## Observing DAG runs

Because the Express.js app deployed as the Cloud Run service representing the job has a 50% chance of failing, and the DAG has retires configured to be 2, you will see some of the DAG runs failing, as intended:

![image](https://user-images.githubusercontent.com/7719209/169408976-e411497f-c271-43db-914d-0108af618aea.png)

Some of the runs that succeeded required two attempts to succeed. You will see this reflected in the "Download Log (by attempts):" part of the UI:

![image](https://user-images.githubusercontent.com/7719209/169409222-77f56da7-b80c-407a-9c37-878b029927fb.png)
