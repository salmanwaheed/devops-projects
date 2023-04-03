#!/bin/bash

sudo yum update -y
sudo yum install -y amazon-cloudwatch-agent nginx stress-ng

sudo systemctl enable amazon-cloudwatch-agent nginx
sudo systemctl restart amazon-cloudwatch-agent nginx

echo "2025-04-21 18:32:45 INFO Starting dummy application
2025-04-21 18:32:46 INFO Initializing modules
2025-04-21 18:32:48 WARN Module X took longer than expected
2025-04-21 18:32:50 ERROR Failed to connect to database
2025-04-21 18:32:52 INFO Retrying connection
2025-04-21 14:05:25 CRITICAL Kernel panic - not syncing
2025-04-21 18:32:55 INFO Connection successful
2025-04-21 18:33:00 INFO Processing data
2025-04-21 14:04:20 ERROR Unauthorized API access attempt detected
2025-04-21 18:33:05 ERROR Data processing failed due to invalid input
2025-04-21 14:10:50 FATAL Unexpected system reboot
2025-04-21 18:33:10 INFO Application shutting down" | sudo tee /var/log/dummy-app.log

sudo amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${ssm_param_name} -s
