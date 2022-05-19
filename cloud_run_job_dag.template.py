import datetime

import airflow
from airflow.operators.python_operator import PythonOperator
from airflow import AirflowException

import requests

# If you are running Airflow in more than one time zone
# see https://airflow.apache.org/docs/apache-airflow/stable/timezone.html
# for best practices
YESTERDAY = datetime.datetime.now() - datetime.timedelta(days=1)

default_args = {
    'owner': 'Composer Example',
    'depends_on_past': False,
    'email': [''],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
    'start_date': YESTERDAY,
}

with airflow.DAG(
        'cloud_run_job_dag',
        catchup=False,
        default_args=default_args,
        schedule_interval=datetime.timedelta(minutes=1)) as dag:

    def call_cloud_run_job():
        r = requests.post('{{cloud_run_url}}')
        if r.status_code == 500:
            msg = f'Cloud Run job failed. Response: {r.content}'
            print(msg)
            raise AirflowException(msg)
        else:
            print(f'Cloud Run job succeeded. Response: {r.content}')

    task_post_op = PythonOperator(
        task_id='call_cloud_run_job_url',
        python_callable=call_cloud_run_job,
        dag=dag,
    )
