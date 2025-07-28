import argparse
import logging
from colorama import Fore, Style
from venom.utils import SUCCESS_LEVEL

class VenomHelpFormatter(
  argparse.ArgumentDefaultsHelpFormatter,
  argparse.RawTextHelpFormatter,
  # argparse.HelpFormatter
):
  # def _get_help_string(self, action):
  #   return action.help or ""

  # def _format_action(self, action):
  #   if action.option_strings:
  #     opts = ", ".join(action.option_strings)
  #     help_text = self._expand_help(action)
  #     return f"  {opts:<25} {help_text}\n"
  #   return super()._format_action(action)

  def _format_action(self, action):
    # spaces between command and help
    if isinstance(action, argparse._SubParsersAction):
      parts = []
      for cmd, subparser in action.choices.items():
        help_text = subparser.description or ''
        parts.append(f"  {cmd:<13} {help_text}")
      return "\n".join(parts) + "\n"

    # spaces between option and help
    if action.option_strings:
      opts = ", ".join(action.option_strings)
      help_text = self._expand_help(action)
      return f"  {opts:<13} {help_text}\n"

    return super()._format_action(action)

  def _get_default_metavar_for_optional(self, action):
    return "" # action.dest

  # def _get_default_metavar_for_positional(self, action):
  #   return action.dest

# print(dir(VenomHelpFormatter))

class VenomColorFormatter(logging.Formatter):
  COLOR_MAP = {
    logging.DEBUG: Fore.CYAN,
    logging.INFO: Fore.GREEN,
    logging.WARNING: Fore.YELLOW,
    logging.ERROR: Fore.RED,
    logging.CRITICAL: Fore.RED + Style.BRIGHT,
    SUCCESS_LEVEL: Fore.LIGHTWHITE_EX,
  }

  def format(self, record):
    color = self.COLOR_MAP.get(record.levelno, "")
    message = super().format(record)
    return f"{color}{message}{Style.RESET_ALL}"
