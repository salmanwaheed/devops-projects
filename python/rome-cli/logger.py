import logging

def setup_logging(level="WARNING"):
  logging.basicConfig(
    level=getattr(logging, level.upper(), logging.WARNING),
    format="%(asctime)s [%(levelname)s] %(message)s",
    # force=True
  )
