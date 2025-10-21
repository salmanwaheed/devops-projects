#!/bin/bash

sudo yum update -y
sudo yum install nginx stress-ng -y

sudo systemctl enable nginx
sudo systemctl restart nginx

AWS_MANAGED_INTERNAL_ENDPOINT=http://169.254.169.254/latest
TOKEN=$(curl -X PUT "${AWS_MANAGED_INTERNAL_ENDPOINT}/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: ${TOKEN}" "${AWS_MANAGED_INTERNAL_ENDPOINT}/meta-data/instance-id")

echo "<h1>Instance ID: ${INSTANCE_ID}</h1>" > /usr/share/nginx/html/index.html
