timeout_milliseconds = 30000           # 30,000 / 1,000 = 30 seconds
domain               = "dummyjson.com" # dummyjson.com
rate_limit           = 50              # allows 50 requests per second.
burst_limit          = 100             # allows up to 100 requests to handle sudden traffic spikes.
username             = "test"
password             = "Test123@"

explicit_auth_flows = [
  "ALLOW_ADMIN_USER_PASSWORD_AUTH",
  "ALLOW_CUSTOM_AUTH",
  "ALLOW_REFRESH_TOKEN_AUTH",
  "ALLOW_USER_AUTH",
  "ALLOW_USER_PASSWORD_AUTH",
  "ALLOW_USER_SRP_AUTH",
]
