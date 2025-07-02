import logging

def add_args(parser):
  parser.add_argument("--bar", metavar="", help="bar value")

def run_app(args, config):
  print("[sub-02] Hello")

  logging.info("Starting app...")
  logging.info(f"ARGS: {args}")
  logging.info(f"CONFIG: {config}")

  logging.info("Finished.")

def register_subparser(subparsers, add_sub):
  add_sub(subparsers, "sub-02", "Run sub-command 02", add_args, run_app)
