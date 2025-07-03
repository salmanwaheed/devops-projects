import sys
import traceback
import argparse
import importlib
import pkgutil
from rome_cli.config import load_config, DEFAULT_CONFIG
from rome_cli.logger import setup_logging
from rome_cli.formatter import SmartHelpFormatter
from rome_cli.validator import validate_required_module
from rome_cli.app import add_args as fallback_add_args, run_app as fallback_run_app

def load_subcommands(subparsers):
  found = False
  import rome_cli.commands
  for loader, module_name, ispkg in pkgutil.iter_modules(rome_cli.commands.__path__):
    module = importlib.import_module(f"rome_cli.commands.{module_name}")
    validate_required_module(module, module_name, ["add_args", "run_app", "register_subparser"])
    module.register_subparser(subparsers, add_custom_subparser)
    found = True
  return found

def add_global_arguments(parser):
  group = parser.add_argument_group("global options")
  group.add_argument("--help", action="help", help="show this help message and exit")
  group.add_argument("--debug", action="store_true", help="Enable debug mode")
  group.add_argument("--config", type=str, default=DEFAULT_CONFIG, metavar="", help=f"Path to config.yml")

def add_custom_subparser(subparsers, name, description, add_args_fn, run_fn):
  parser = subparsers.add_parser(
    name,
    help=description,
    add_help=False,
    usage=f"rome-cli {name} [OPTIONS]",
    formatter_class=SmartHelpFormatter
  )
  add_args_fn(parser)
  add_global_arguments(parser)
  parser.set_defaults(func=run_fn, _subparser=parser)

def main():
  parser = argparse.ArgumentParser(
    prog="rome-cli",
    description="ROME CLI Tool",
    add_help=False,
    usage="rome-cli [OPTIONS] <subcommand> [ARGS]",
    formatter_class=SmartHelpFormatter
  )

  add_global_arguments(parser)
  fallback_add_args(parser)
  subparsers = parser.add_subparsers(title="subcommands", metavar="", dest="command")
  load_subcommands(subparsers)

  args = parser.parse_args()

  if len(sys.argv) == 1:
    parser.print_help()
    parser.exit(0)
  elif hasattr(args, "_subparser") and args.command and len(sys.argv) == 2:
    args._subparser.print_help()
    parser.exit(0)

  try:
    config = load_config(config_path=args.config)
    log_level = "DEBUG" if args.debug else config.get("log_level", "WARNING")
    setup_logging(level=log_level)

    if hasattr(args, "func"): # attempt to auto-load subcommands from rome_cli.commands
      args.func(args, config)
    else: # fallback to default logic from app.py
      fallback_run_app(args, config)

  except Exception as e:
    if args.debug:
      traceback.print_exc()
    else:
      print(f"[!] Error: {e}")
    parser.exit(1)
