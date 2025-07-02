import logging

def register_subparser(subparsers):
  parser = subparsers.add_parser("sub-02", help="Do something for sub-02")
  parser.add_argument("--bar", help="bar value")
  parser.set_defaults(func=run_app)

def run_app(args, config):
  print("[sub-02] Hello")

  logging.info("Starting app...")
  logging.info(f"ARGS: {args}")
  logging.info(f"CONFIG: {config}")

  logging.info("Finished.")
