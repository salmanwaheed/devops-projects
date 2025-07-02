import logging

def add_args(parser):
  parser.add_argument("--foo", metavar="", help="foo value")

def run_app(args, config):
  print("[sub-01] Hello")

  logging.info("Starting app...")
  logging.info(f"ARGS: {args}")
  logging.info(f"CONFIG: {config}")

  logging.info("Finished.")

def register_subparser(subparsers, add_sub):
  add_sub(subparsers, "sub-01", "Run sub-command 01", add_args, run_app)
