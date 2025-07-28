from venom.cli import VenomCLI
import logging

cli = VenomCLI()
cli.verbose()
cli.version("0.1.0", command=True)

# root option without custom function, no subcommand
# cli.root_option("--help", action="help", help="show this help message and exit")

# root option with custom function, no subcommand
@cli.root_option("--src", help="src path")
@cli.root_option("--dest", help="dest path")
def my_file(src, dest):
  print("{} {} {}".format(my_file.__name__, src, dest))

# subcommand with option
@cli.command(name="just-print", help="just-print my name")
@cli.option('--name', help="Your name")
# @cli.option("--help", action="help", help="show this help message and exit")
def my_name(name):
  print(f"Hello {name}")
  logging.debug("Debug message")
  logging.info("Info message")
  logging.warning("Warning message")
  logging.error("Error message")
  logging.critical("Critical message")
  logging.success("Critical message")

# subcommand without option
# @cli.command(name="version", help="just-print version")
# def my_version():
#   print(f"version 0.1.0")

cli.run()
