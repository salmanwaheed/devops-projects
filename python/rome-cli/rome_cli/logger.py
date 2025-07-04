import logging
from colorama import Fore, Style, init as colorama_init

colorama_init(autoreset=True)

class ColorFormatter(logging.Formatter):
  COLOR_MAP = {
    logging.DEBUG: Fore.BLUE,
    logging.INFO: Fore.GREEN,
    logging.WARNING: Fore.YELLOW,
    logging.ERROR: Fore.RED,
    logging.CRITICAL: Fore.RED + Style.BRIGHT
  }

  def format(self, record):
    color = self.COLOR_MAP.get(record.levelno, "")
    return f"{color}[{record.levelname}] {record.getMessage()}{Style.RESET_ALL}"

def setup_logging(level="DEBUG"):
  logger = logging.getLogger()
  logger.setLevel(level.upper())

  if not logger.handlers:
    handler = logging.StreamHandler()
    handler.setFormatter(ColorFormatter())
    logger.addHandler(handler)

setup_logging()

# logging.debug("Debug message")
# logging.info("Info message")
# logging.warning("Warning message")
# logging.error("Error message")
# logging.critical("Critical message")
