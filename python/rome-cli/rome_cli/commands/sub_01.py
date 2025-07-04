import logging

def add_args(parser):
  parser.add_argument("--foo", metavar="", help="foo value")

def run_app(args, config):
  logging.success(f"[{args.command}] Hello")

  ## check if log_level == "TRACE" working or not.
  # raise RuntimeError("Intentional test error")

  logging.warning("Warning message 01....")
  logging.debug("Debug message 01....")

  logging.info("Starting app...")
  logging.info(f"ARGS: {args}")

  logging.warning("Warning message 02....")
  logging.debug("Debug message 02....")

  logging.info(f"CONFIG: {config}")
  logging.info("Finished.")

  logging.warning("Warning message 03....")
  logging.debug("Debug message 03....")

def register_subparser(subparsers, add_sub):
  add_sub(subparsers, "sub-01", "Run sub-command 01", add_args, run_app)
