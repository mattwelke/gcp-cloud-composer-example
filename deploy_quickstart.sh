#!/bin/bash

gcloud composer environments storage dags import \
--environment my-environment --location us-central1 \
--source quickstart.py
