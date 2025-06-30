import os
import sys
import yaml
import argparse
import traceback

# Prevent .pyc and __pycache__
sys.dont_write_bytecode = True

# Debug toggle via ENV
DEBUG = os.getenv("DEBUG", "false").lower() == "true"

DEFAULT_CONFIG = "/etc/rome-cli/config.yml"

def load_config(path: str) -> dict:
  if not os.path.isfile(path):
    raise FileNotFoundError(f"Config not found at: {path}")
  with open(path, "r") as f:
    return yaml.safe_load(f) or {}

def parse_args():
  parser = argparse.ArgumentParser(description="Secure app to load secrets from YAML")
  parser.add_argument(
    "--config",
    "-c",
    default=DEFAULT_CONFIG,
    help=f"Path to config file (default: {DEFAULT_CONFIG})"
  )
  return parser.parse_args()

def main():
  try:
    args = parse_args()
    print("Running secure app...")

    # Load environment variable
    env_key = os.getenv("SECRET_KEY", "Not set")
    print(f"ENV: {env_key}")

    # Load YAML secrets
    config = load_config(args.config)
    yaml_key = config.get("secret_key", "Not set")
    print(f"YAML: {yaml_key}")

  except Exception as e:
    if DEBUG:
      traceback.print_exc()
    else:
      print(f"[!] Error: {e}")
    sys.exit(1)

if __name__ == "__main__":
  main()
