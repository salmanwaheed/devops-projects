import sys
import traceback
import argparse
from config import load_config, DEFAULT_CONFIG
from logger import setup_logging
from app import run_app

def main():
  parser = argparse.ArgumentParser(description="Salman Waheed - rome-cli", add_help=False)

  parser.add_argument("--help", action="help", help="Show this help message and exit")
  parser.add_argument("--debug", action="store_true", help="Enable debug mode")
  parser.add_argument("--config", type=str, default=DEFAULT_CONFIG, help=f"Path to config.yml (default: {DEFAULT_CONFIG})")

  args = parser.parse_args()

  try:
    config = load_config(config_path=args.config)
    log_level = "DEBUG" if args.debug else config.get("log_level", "WARNING")
    setup_logging(level=log_level)

    run_app(config=config)
  except Exception as e:
    if args.debug:
      traceback.print_exc()
    else:
      print(f"[!] Error: {e}")
    sys.exit(1)
