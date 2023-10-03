import io
import logging
import os
from dataclasses import asdict, dataclass
from typing import Optional

import boto3
import pandas as pd
from botocore.exceptions import NoCredentialsError
from decouple import config
import uuid

# Set up logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

@dataclass
class AwsConnection:
    aws_access_key_id: Optional[str]
    aws_secret_access_key: Optional[str]
    region_name: Optional[str]



def get_aws() -> AwsConnection:
    return AwsConnection(
        aws_access_key_id=config("AWS_ACCESS_KEY"),
        aws_secret_access_key=config("AWS_SECRET_KEY"),
        region_name="us-east-1"
    )


def row_exists_in_csv(s3_client, bucket_name, s3_file_path, event_url):
    try:
        # Download the existing CSV file from S3
        response = s3_client.get_object(Bucket=bucket_name, Key=s3_file_path)
        existing_data = response["Body"].read().decode("utf-8")

        # Create a DataFrame from the existing data
        existing_df = pd.read_csv(io.StringIO(existing_data))

        # Check if the event URL already exists in the CSV
        url_exists = (existing_df["url"] == event_url).any()
        return url_exists

    except s3_client.exceptions.NoSuchKey:
        return False


def save_to_csv_s3(s3_file_path, event_details, exclude_columns=None):
    try:
        bucket_name = "uvent-bucket"
        s3_client = boto3.client("s3", **asdict(get_aws()))

        try:
            response = s3_client.get_object(Bucket=bucket_name, Key=s3_file_path)
            existing_data = response["Body"].read().decode("utf-8")
            existing_df = pd.read_csv(io.StringIO(existing_data))
        except s3_client.exceptions.NoSuchKey:
            existing_df = pd.DataFrame()

        events_to_append = []
        for event in event_details:
            event_url = event["url"]
            if not row_exists_in_csv(s3_client, bucket_name, s3_file_path, event_url):
                events_to_append.append(event)

        if not events_to_append:
            logging.info("No new events to append")
            return

        df_to_append = pd.DataFrame(events_to_append)

        if exclude_columns:
            df_to_append = df_to_append.drop(columns=exclude_columns)

        # Concatenate the new events with the existing data
        concatenated_df = pd.concat([existing_df, df_to_append], ignore_index=True)

        csv_buffer = io.StringIO()
        concatenated_df.to_csv(csv_buffer, index=False)
        csv_data = csv_buffer.getvalue().encode("utf-8")

        # Upload the concatenated CSV buffer to S3
        s3_client.put_object(Body=csv_data, Bucket=bucket_name, Key=s3_file_path)

        logging.info(f"{len(events_to_append)} events appended to CSV in S3.")

    except NoCredentialsError:
        logging.error("AWS credentials not available.")
