import json
from secrets import access_key, secret_access_key

from datetime import datetime
from time import time

#Create a variable to save data and time values and attach these values to the file name
time_now = datetime.now().strftime('_%d_%m_%Y_%H_%M_%S_%p') 

import boto3
import os
import requests

#Using requests library to curl the export API of RabbitMQ with admin user credentials
rabbit = requests.get('rabbitmqendpoint/api/definitions', auth=('username', 'password'))
with open("rabbit-pre-prod.json", "wb") as f:
    f.write(rabbit.content)

#Passing AWS account secrets as varibles taken from secrets.py file
client = boto3.client('s3',
                        aws_access_key_id = access_key,
                        aws_secret_access_key = secret_access_key)

#Function to upload the file to S3 bucket
for file in os.listdir():
    if '.json' in file:
        upload_file_bucket = 'bucket-name'
        upload_file_key = 'foldername/' + str(file + time_now)
        client.upload_file(file, upload_file_bucket, upload_file_key)

os.remove("rabbit-pre-prod.json")
