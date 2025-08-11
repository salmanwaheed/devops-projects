import os
import sys
import traceback
import argparse
import logging
import inspect
from pathlib import Path
from venom.logger import VenomLogger
from venom.formatter import VenomHelpFormatter

class VenomCLI:
  def __init__(self, name="venom", desc="VENOM CLI Tool", add_help=False, config=None):
    self.name = str(name)
    self.desc = str(desc)
    self.add_help = bool(add_help)
    self.__venom_version = None
    self.__venom_commands = {}
    self.__venom_root_options = {}

    self.config_dir = self.__init_config_dir(config=config)

  def __init_config_dir(self, config: str | None) -> Path:
    # use "VENOM_CONFIG" or "config" if available, otherwise fallback to "~/.config/venom"
    custom_env = os.getenv(f"{self.name.upper()}_CONFIG")
    if custom_env:
      base_dir = Path(custom_env).expanduser()
    elif config:
      base_dir = Path(config).expanduser()
    else:
      base_dir = Path.home() / ".config"

    config_dir = base_dir / self.name
    config_dir.mkdir(parents=True, exist_ok=True) # ensure folder exists
    return config_dir

  def __call_func_with_matching_args(self, func, args):
    """
    Calls `func` with only the arguments it accepts from `args`.
    """
    sig = inspect.signature(func)

    # filter only matching args
    filtered_kwargs = {
      k: v for k, v in vars(args).items()
      if k in sig.parameters
    }

    return func(**filtered_kwargs)

  def __venom_should_show_command_help(self, args):
    return (
      hasattr(args, "_subparser") and
      args.command and
      len(sys.argv) == 2 and
      self.__venom_commands.get(args.command, {}).get("options")
    )

  def __venom_register_options(self, func, attr_name, *flags, **kwargs):
    if not hasattr(func, attr_name):
      setattr(func, attr_name, [])
    getattr(func, attr_name).append({ "flags": list(flags), "kwargs": dict(kwargs) })
    return func

  def get_config_file(self, filename: str) -> Path:
    return self.config_dir / filename

  def require_options_if(self, args: dict, flag: str, required: list):
    if args.get(flag):
      missing = [opt for opt in required if not args.get(opt)]
      if missing:
        raise ValueError(
            f"When using --{flag.replace('_', '-')}, the following options are required: "
            + ", ".join(f"--{opt.replace('_', '-')}" for opt in missing)
        )

  def command(self, name=None, help=None):
    def decorator(func):
      cmd_name = name or func.__name__
      self.__venom_commands[cmd_name] = {
        "handler": func,
        "help": help or func.__doc__ or "",
        "options": getattr(func, "__venom_options", [])
      }
      return func
    return decorator

  def option(self, *flags, **kwargs):
    def decorator(func):
      self.__venom_register_options(func, "__venom_options", *flags, **kwargs)
      return func
    return decorator

  def root_option(self, *flags, **kwargs):
    def decorator(func):
      self.__venom_register_options(func, "__venom_root_options", *flags, **kwargs)
      self.__venom_root_options[func.__name__] = {
        "handler": func,
        "options": getattr(func, "__venom_root_options", [])
      }
      return func

    is_action = kwargs.get("action", None)
    if is_action:
      self.__venom_root_options[is_action] = {
        "handler": None,
        "options": [{"flags": list(flags), "kwargs": dict(kwargs)}]
      }
    else:
      return decorator

  def version(self, version, command=True, help="show version and exit"):
    self.__venom_version = version
    _message = "{} v{}".format(self.name, self.__venom_version)

    if command:
      @self.command(name=f"version", help=help)
      def _venom_version():
        print(_message)
      return _venom_version

    return self.root_option("--version", action="version", version=_message, help=help)

  def verbose(self, help="verbosity (-v: INFO, -vv: DEBUG, -vvv: TRACE)"):
    return self.root_option("-v", action="count", default=0, help=help)

  def run(self):
    parser = argparse.ArgumentParser(
      prog=self.name,
      description=self.desc,
      add_help=self.add_help,
      usage="%(prog)s <command> [OPTIONS]",
      formatter_class=VenomHelpFormatter
    )

    group = parser.add_argument_group("options")
    for root_cmd_name, root_meta in self.__venom_root_options.items():
      for root_options in root_meta["options"]:
        group.add_argument(*root_options["flags"], **root_options["kwargs"])
      group.set_defaults(_handler=root_meta["handler"])

    subparsers = parser.add_subparsers(
      prog=self.name, title="commands", dest="command"
    )

    for sub_cmd_name, sub_meta in self.__venom_commands.items():
      sub = subparsers.add_parser(
        sub_cmd_name,
        help=sub_meta["help"],
        description=sub_meta["help"],
        add_help=self.add_help,
        usage="%(prog)s [OPTIONS]",
        formatter_class=VenomHelpFormatter
      )
      for sub_options in sub_meta["options"]:
        sub.add_argument(*sub_options["flags"], **sub_options["kwargs"])
      sub.set_defaults(_handler=sub_meta["handler"], _subparser=sub)

    if len(sys.argv) == 1:
      parser.print_help()
      parser.exit(0)

    args = parser.parse_args()

    log_level = {
      0: logging.WARNING,
      1: logging.INFO,
      2: logging.DEBUG,
    }.get(getattr(args, "v", 0), logging.NOTSET)

    VenomLogger(log_level)

    if self.__venom_should_show_command_help(args):
      args._subparser.print_help()
      parser.exit(0)

    try:
      if hasattr(args, "_handler"):
        # Get only the args from argparse that match the function's parameters
        self.__call_func_with_matching_args(args._handler, args)
      else:
        print("No command found.")
    except Exception as e:
      if log_level == logging.NOTSET:
        traceback.print_exc()
      else:
        parser.error(str(e))
      parser.exit(1)
