# https://docs.gunicorn.org/en/stable/settings.html#config
bind = ":5000"
workers = 2
timeout = 30

accesslog = "-"
errorlog = "-"

loglevel = "info" # "debug", "info", "warning", "error", "critical"
keepalive = 2 # seconds to keep connections alive (default: 2)

access_log_format = ('%(t)s %(r)s ip_address=%(h)s status_code=%(s)s response_time=%(L)s')
