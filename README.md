# gcp-cloud-composer-example

A tutorial on how to:

- Create a Cloud Composer 1 instance
- Do local development in VS Code on a DAG
- Deploy the DAG to the environment
- See the deployed DAG in the Airflow Web UI.

Composer version: composer-1.18.8-airflow-1.10.15
Airflow version: 1.10.15

Prereqs:

- VS Code
- pyenv (https://github.com/pyenv/pyenv)
- Python installed via pyenv (version determined during tutorial)

## Creating Composer environment

Create a new GCP project so that it's easy to delete all resources created automatically when finished.

To create the environment, enable the Composer API in the project and then run `./create_environment.sh`.

Wait for the environment to be created.

## Local development with VS Code

When you set up an IDE like VS Code for local dev with Python, you'll get code completion for built in Python packages (like `datetime`) but you won't get code completion for 3rd party packages (like `airflow`) unless you install those packages onto your dev machine too:

![image](https://user-images.githubusercontent.com/7719209/169361891-4b797de6-5f59-429c-ba80-b3cd7a5b83d3.png)

Code completion:

![image](https://user-images.githubusercontent.com/7719209/169361941-5d8958e7-bee5-4e44-afe9-4a3479ea7624.png)

No code completion:

![image](https://user-images.githubusercontent.com/7719209/169362006-4f5a61d6-0fb6-45b0-a8e9-904ff9bbbf46.png)

The solution to this problem is to create a `requirements.txt` file in the project with the Airflow version running in your Composer environment. Then, developers cloning the project to their workstation can use `pip` to install the exact Airflow version (and optionally, exact versions of other pip packages running in the Composer environment) to their workstation's virtual environment.

To find the Airflow version, you can check https://cloud.google.com/composer/docs/concepts/versioning/composer-versions. For example, because we know we're using the image composer-1.18.8-airflow-1.10.15 in `create_environment.sh`, we show our Airflow version is 1.10.15. It's also a good idea to note the exact Python version being used in the environment too, so that the virtual environment used locally can match the Composer environment exactly. For example, we see that the environment is using Python 3.8.12:

![image](https://user-images.githubusercontent.com/7719209/169362675-4b4ff555-1bba-44d2-888e-2a7ef4646b18.png)

We can then record our Airflow version and Python version into the project:

```
echo 'apache-airflow==1.10.15' > requirements.txt
```

```
# creates .python-version file, which VS Code will pick up
pyenv local 3.8.12
```

And now we can create the virtual environment and install the Airflow package into it:

```
python -m venv .venv
```

(reload window in VS Code so it picks up the virtual environment)

Select the virtual environment using the "Select Interpreter" prompt:

![image](https://user-images.githubusercontent.com/7719209/169363120-10f31468-a9a4-40d7-9e19-61547081c730.png)

Install the packages into the virtual environment:

```
pip install -r requirements.txt
```

Now, we can get code completion for the Python packages running in the Composer environment too. Our local development environment more closely matches the production environment into which we'll deploy our DAG:

![image](https://user-images.githubusercontent.com/7719209/169364522-958b5033-1dd9-4523-8192-03465a446cb5.png)

## Deploying to Composer environment in GCP

After waiting for the environment to be created, deploy the quickstart DAG with `./deploy_quickstart.sh`. This script uses `gcloud` to upload the DAG file to the environment (which involves copying it into the DAG bucket for the environment).

To see our deployed DAG, we need to go to the web UI. Find it by viewing the config for your Composer environment, "Airflow web UI":

![image](https://user-images.githubusercontent.com/7719209/169363864-79f908c0-de01-47ea-940e-9a040c22c436.png)

You won't see the new DAG right away, but after a few minutes, Airflow will have synced with the DAG bucket, and it will appear and begin running according to its schedule:

![image](https://user-images.githubusercontent.com/7719209/169364122-8e763900-231c-48fb-994b-3a1f1a5394e8.png)

## Teardown

Delete the GCP project to delete all the resources created.
