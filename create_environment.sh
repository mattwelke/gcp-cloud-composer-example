#!/bin/bash

gcloud beta composer environments create my-composer2-env \
    --location us-central1 \
    --image-version composer-2.0.16-airflow-2.2.5 # uses Python 3.8.12

