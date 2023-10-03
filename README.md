## Web Scraping with Airflow

This README provides step-by-step instructions on setting up and running a web scraping project using Apache Airflow. The project involves scraping data from aan ecommerce site(tonaton.com) using Airflow's scheduling capabilities. Below are the key steps to set up and run the project.

### Step 1: Build the Airflow Docker Image

Build the Airflow Docker image using the provided Dockerfile:

```bash
docker build -f Dockerfile.Airflow . -t airflow-scraper
```

This command will create an Airflow image named `airflow-scraper`.

### Step 2: Create Project Folders

Create the necessary project folders for your Airflow environment, including `dags`, `logs`, and `plugins`:

```bash
mkdir ./dags ./logs ./plugins
```

### Step 3: Set Environment Variables

Create an `.env` file to set the Airflow user ID (UID) and group ID (GID). Your `.env` file should look like this:

```bash
AIRFLOW_UID=33333
AIRFLOW_GID=0
```

This ensures that Airflow runs with the correct permissions.

### Step 4: Start Airflow and Spark Containers

Start the Airflow and Spark containers using Docker Compose:

```bash
docker-compose -f docker-compose.Airflow.yaml up -d
```

This command will launch the containers in the background.

### Step 5: Define and Configure the DAG

Define and configure the Airflow DAG for your web scraping task. Ensure that the DAG includes the necessary tasks, operators, and dependencies. Customize the DAG according to your web scraping requirements.

### Step 6: Run the Web Scraping DAG

Once the DAG is defined and configured, you can trigger its execution through the Airflow CLI or web interface. The DAG will schedule and run your web scraping task at the specified intervals.

### Step 7: Monitor and Troubleshoot

Monitor the progress of your web scraping tasks using the Airflow web interface or command-line tools. You can view logs, check task statuses, and troubleshoot any issues that may arise during the execution of the DAG.

### Step 8: Customize and Scale

Feel free to customize the web scraping logic, add more tasks, or scale the project as needed. You can adjust scheduling intervals, add error handling, or integrate with external data storage systems to enhance your web scraping pipeline.

## Conclusion

With these steps, you can set up a web scraping project using Apache Airflow, allowing you to automate data extraction from websites on a scheduled basis. Ensure that you adhere to the website's terms of service and legal regulations when performing web scraping activities.