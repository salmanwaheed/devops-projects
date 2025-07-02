import sys
import traceback
import argparse
import importlib
import pkgutil
from rome_cli.config import load_config, DEFAULT_CONFIG
from rome_cli.logger import setup_logging
# from rome_cli.app import run_app

def main():
  parser = argparse.ArgumentParser(
    prog="rome-cli",
    description="ROME CLI Tool",
    add_help=False,
    usage="rome-cli [OPTIONS] <subcommand> [ARGS]",
  )

  parser.add_argument("--help", action="help", help="Show this help message and exit")
  parser.add_argument("--debug", action="store_true", help="Enable debug mode")
  parser.add_argument("--config", type=str, default=DEFAULT_CONFIG, help=f"Path to config.yml (default: {DEFAULT_CONFIG})")

  subparsers = parser.add_subparsers(title="subcommands", metavar="", dest="command")
  # dynamically load subcommands from commands/
  import rome_cli.commands
  for loader, module_name, ispkg in pkgutil.iter_modules(rome_cli.commands.__path__):
    module = importlib.import_module(f"rome_cli.commands.{module_name}")
    if hasattr(module, "register_subparser"):
      module.register_subparser(subparsers)

  args = parser.parse_args()

  try:
    config = load_config(config_path=args.config)
    log_level = "DEBUG" if args.debug else config.get("log_level", "WARNING")
    setup_logging(level=log_level)

    if args.command is None:
      parser.print_help()
      sys.exit(0)

    # call the single command
    # run_app(args, config)

    # call the sub-commands
    args.func(args, config)
  except Exception as e:
    if args.debug:
      traceback.print_exc()
    else:
      print(f"[!] Error: {e}")
    sys.exit(1)
