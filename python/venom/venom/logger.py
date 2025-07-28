import logging
from colorama import init
from venom.formatter import VenomColorFormatter
from venom.utils import SUCCESS_LEVEL

class VenomLogger:
  def __init__(self, level=logging.WARNING, use_color=True):
    if use_color:
      init(autoreset=True)

    formatter = VenomColorFormatter("[%(levelname)s] %(message)s")

    handler = logging.StreamHandler()
    handler.setFormatter(formatter)

    logging.addLevelName(SUCCESS_LEVEL, "SUCCESS")
    logging.success = self._success

    logger = logging.getLogger()
    logger.setLevel(level)

    if not logger.handlers:
      logger.addHandler(handler)

  def _success(self, message, *args, **kwargs):
    logging.log(SUCCESS_LEVEL, message, *args, **kwargs)

# VenomLogger(logging.DEBUG) # or INFO, WARNING, etc.

# logging.debug("Debug message")
# logging.info("Info message")
# logging.warning("Warning message")
# logging.error("Error message")
# logging.critical("Critical message")
# logging.success("Critical message")
