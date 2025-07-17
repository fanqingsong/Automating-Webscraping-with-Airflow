from datetime import timedelta
import airflow
from airflow import DAG
from airflow.operators.python import PythonOperator
from dags.tonaton_scraper import get_products

default_args = {
    "owner": "airflow",
    "retry_delay": timedelta(minutes=5),
}

# set up dag
with DAG(
    "scraper_dag",
    default_args=default_args,
    description="Run scraper with python operator",
    start_date=airflow.utils.dates.days_ago(1),
    schedule_interval="@daily",
    catchup=False,
) as dag:
    tonaton_scraper = PythonOperator(
        task_id="egotickets_scraper",
        python_callable=get_products.run,
    )
