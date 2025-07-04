import sys
import traceback
import argparse
import importlib
import pkgutil
from rome_cli import __version__
from rome_cli.config import load_config, DEFAULT_CONFIG
from rome_cli.logger import setup_logging
from rome_cli.formatter import SmartHelpFormatter
from rome_cli.validator import validate_required_module

try:
  from rome_cli.app import add_args as fallback_add_args
except ImportError:
  fallback_add_args = None

try:
  from rome_cli.app import run_app as fallback_run_app
except ImportError:
  fallback_run_app = None

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
  group.add_argument("--config", type=str, default=DEFAULT_CONFIG, metavar="", help=f"optional path to config.yml")
  group.add_argument("-v", action="count", default=0, help=f"verbosity level (-v (INFO), -vv (DEBUG), -vvv (TRACE))")

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
  parser.add_argument("--init-config", action="store_true", help=f"generate sample {DEFAULT_CONFIG} file and exit")
  parser.add_argument("--version", action="version", version=f"%(prog)s v{__version__}", help="show version and exit")

  module = importlib.import_module("rome_cli.app")
  validate_required_module(module, "app", ["add_args", "run_app"])

  add_global_arguments(parser)

  if fallback_add_args:
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

  log_level = {
    0: "WARNING",
    1: "INFO",
    2: "DEBUG"
  }.get(args.v, "NOTSET")

  try:
    if args.init_config:
      from rome_cli.config import init_config_file
      init_config_file(config_path=args.config)
      print(f"Sample config file created at: {args.config}")
      parser.exit(0)

    config = load_config(config_path=args.config)
    setup_logging(level=log_level)

    if hasattr(args, "func"): # attempt to auto-load subcommands from rome_cli.commands
      args.func(args, config)
    elif fallback_run_app: # fallback to default logic from app.py
      fallback_run_app(args, config)

  except Exception as e:
    if log_level == "NOTSET":
      traceback.print_exc()
    else:
      parser.error(e)
    parser.exit(1)
