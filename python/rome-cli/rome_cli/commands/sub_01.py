import logging

def register_subparser(subparsers):
  parser = subparsers.add_parser("sub-01", help="Do something for sub-01")
  parser.add_argument("--foo", help="foo value")
  parser.set_defaults(func=run_app)

def run_app(args, config):
  print("[sub-01] Hello")

  logging.info("Starting app...")
  logging.info(f"ARGS: {args}")
  logging.info(f"CONFIG: {config}")

  logging.info("Finished.")
