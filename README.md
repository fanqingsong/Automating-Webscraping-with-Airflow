# Web Scraping with Airflow

This project provides step-by-step instructions on setting up and running a web scraping project using Apache Airflow. The project involves scraping data from an ecommerce site (tonaton.com) using Airflow's scheduling capabilities.

## Quick Start

### Using Management Scripts (Recommended)

We provide convenient management scripts in the `bin/` directory for easy service management:

```bash
# Start Airflow services
./bin/start.sh

# Stop Airflow services
./bin/stop.sh

# Restart Airflow services
./bin/restart.sh

# Check service status
./bin/status.sh

# Stop and clean all data
./bin/stop.sh --clean
```

### Airflow Access Information

Once the services are running, you can access:

- **Airflow Web UI**: http://localhost:9090
- **Flower Monitoring**: http://localhost:5555

**Default Login Credentials:**
- **Username**: `airflow`
- **Password**: `airflow`

## Manual Setup

### Step 1: Build the Airflow Docker Image

Build the Airflow Docker image using the provided Dockerfile:

```bash
docker build -f Dockerfile . -t airflow-scraper
```

This command will create an Airflow image named `airflow-scraper`.

### Step 2: Create Project Folders

Create the necessary project folders for your Airflow environment:

```bash
mkdir -p ./dags ./logs ./plugins
chmod -R 777 ./dags ./logs ./plugins
```

### Step 3: Set Environment Variables

Create an `.env` file to set the Airflow user ID (UID). Your `.env` file should look like this:

```bash
AIRFLOW_UID=$(id -u)
```

This ensures that Airflow runs with the correct permissions.

### Step 4: Start Airflow Services

Start the Airflow services using Docker Compose:

```bash
docker compose up -d
```

Or if you prefer the legacy command:

```bash
docker-compose -f docker-compose.yaml up -d
```

This command will launch all containers in the background.

### Step 5: Access Airflow Web Interface

1. Open your browser and navigate to: http://localhost:9090
2. Login with the default credentials:
   - Username: `airflow`
   - Password: `airflow`

### Step 6: Define and Configure the DAG

Define and configure the Airflow DAG for your web scraping task. Ensure that the DAG includes the necessary tasks, operators, and dependencies. Customize the DAG according to your web scraping requirements.

### Step 7: Run the Web Scraping DAG

Once the DAG is defined and configured, you can trigger its execution through the Airflow CLI or web interface. The DAG will schedule and run your web scraping task at the specified intervals.

### Step 8: Monitor and Troubleshoot

Monitor the progress of your web scraping tasks using:
- **Airflow Web UI**: http://localhost:9090
- **Flower Monitoring**: http://localhost:5555
- **Command Line**: `docker compose logs -f`

You can view logs, check task statuses, and troubleshoot any issues that may arise during the execution of the DAG.

## Management Scripts Details

### `bin/start.sh`
- Automatically sets `AIRFLOW_UID` environment variable
- Creates necessary directories with proper permissions
- Checks Docker status
- Starts all Airflow services
- Displays service status and access information

### `bin/stop.sh`
- Stops all Airflow containers
- Supports `--clean` or `-c` flag to remove volumes and data
- Usage: `./bin/stop.sh --clean` to completely reset the environment

### `bin/restart.sh`
- Stops existing services
- Waits for cleanup
- Restarts all services
- Useful for applying configuration changes

### `bin/status.sh`
- Shows current container status
- Displays access URLs and credentials
- Lists available management commands

## Environment Variables

The following environment variables can be set in your `.env` file:

```bash
# Required
AIRFLOW_UID=$(id -u)

# Optional - Custom login credentials
_AIRFLOW_WWW_USER_USERNAME=your_username
_AIRFLOW_WWW_USER_PASSWORD=your_password

# Optional - API Keys for web scraping
AWS_ACCESS_KEY=your_aws_access_key
AWS_SECRET_KEY=your_aws_secret_key
EVENTBRITE_API_KEY=your_eventbrite_api_key
OPENGATE_API_KEY=your_opengate_api_key
```

## Troubleshooting

### Permission Issues
If you encounter permission errors, ensure:
1. The `logs`, `dags`, and `plugins` directories have proper permissions
2. The `AIRFLOW_UID` environment variable is set correctly
3. Run: `chmod -R 777 logs dags plugins`

### Service Not Starting
1. Check if Docker is running: `docker info`
2. Verify no port conflicts (9090, 5555, 5432, 6379)
3. Check logs: `docker compose logs -f`

### Reset Environment
To completely reset the environment:
```bash
./bin/stop.sh --clean
./bin/start.sh
```

## Customization and Scaling

Feel free to customize the web scraping logic, add more tasks, or scale the project as needed. You can:
- Adjust scheduling intervals
- Add error handling
- Integrate with external data storage systems
- Add more DAGs for different scraping tasks

## Conclusion

With these steps, you can set up a web scraping project using Apache Airflow, allowing you to automate data extraction from websites on a scheduled basis. The provided management scripts make it easy to start, stop, and monitor your Airflow environment.

**Important**: Ensure that you adhere to the website's terms of service and legal regulations when performing web scraping activities.