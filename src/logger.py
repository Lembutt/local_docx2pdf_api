from loguru import logger
from os import path
from pathlib import Path

logs = path.join(
    Path(__file__),
    "..",
    "..",
    "logs/"
)

debug_path = path.join(logs, 'debug.log')

error_path = path.join(logs, 'error.log')


logger.add(
    debug_path,
    level="DEBUG",
    format="{time} {level} {message}",
    colorize=True,
    serialize=True
)

logger.add(
    error_path,
    level="ERROR",
    format="{time} {level} {message}",
    colorize=True
)
