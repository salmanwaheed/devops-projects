import argparse

class SmartHelpFormatter(argparse.ArgumentDefaultsHelpFormatter, argparse.HelpFormatter):

  def _format_action(self, action):
    if isinstance(action, argparse._SubParsersAction):
      parts = super()._format_action(action).splitlines()
      # Remove blank lines and fix indent
      cleaned = [f"  {line.strip()}" for line in parts if line.strip()]
      return "\n".join(cleaned)
    return super()._format_action(action)
