import yaml
import os
import subprocess
import logging
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

  if not path.exists():
    logging.warning(f"Config file not found at {path}. Using empty config.")
    return {}

  with open(path, "r") as f:
    return yaml.safe_load(f)

def init_config_file(config_path=None):
    p = resolve_config_path(config_path)

    if p.exists():
      raise FileExistsError(f"Config file already exists: {p}")

    if not p.parent.exists():
      # p.parent.mkdir(parents=True, exist_ok=True)
      subprocess.run(["sudo", "mkdir", "-p", str(p.parent)], check=True)
      subprocess.run(["sudo", "chown", f"{os.getuid()}:{os.getgid()}", str(p.parent)], check=True)

    sample_config = {
      "whoami": f"Salman Waheed - loading from {p}"
    }

    with open(p, "w") as f:
      yaml.dump(sample_config, f, default_flow_style=False)
