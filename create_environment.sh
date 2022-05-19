#!/bin/bash

gcloud composer environments create my-environment \
    --location us-central1 \
    --image-version composer-1.18.8-airflow-1.10.15 # uses Python 3.8.12
