import logging

def add_args(parser):
  parser.add_argument("--zoo", metavar="", help="zoo value")

def run_app(args, config):
  print("No subcommands detected. Fallback to default logic from app.py...")

  logging.info("Starting app...")
  logging.info(f"ARGS: {args}")
  logging.info(f"CONFIG: {config}")

  logging.info("Finished.")

# def register_subparser(subparsers, add_sub):
#   add_sub(subparsers, "sub-01", "Run main command", add_args, run_app)
