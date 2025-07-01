import yaml
from pathlib import Path

DEFAULT_CONFIG = Path("/etc/rome-cli/config.yml")

# DEFAULT_CONFIG.parent # /etc/rome-cli
# DEFAULT_CONFIG.name # config.yml

def resolve_config_path(path=None):
  p = Path(path) if path else DEFAULT_CONFIG

  if p.is_dir():
    p = p / DEFAULT_CONFIG.name

  if p.name != DEFAULT_CONFIG.name:
    raise ValueError(f"Config file must be named '{DEFAULT_CONFIG.name}', got: {p.name}")

  return p

def load_config(config_path=None):
  path = resolve_config_path(config_path)
  with open(path, "r") as f:
    return yaml.safe_load(f)
