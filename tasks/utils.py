"""
Invoke utilities.
"""
from __future__ import annotations

import pathlib
import sys

try:
    from blessings import Terminal

    try:
        terminal = Terminal()
        HAS_BLESSINGS = True
    except Exception:  # pylint: disable=broad-except
        terminal = None
        HAS_BLESSINGS = False
except ImportError:
    terminal = None
    HAS_BLESSINGS = False

REPO_ROOT = pathlib.Path(__file__).parent.parent

print(REPO_ROOT)


def exit_invoke(exitcode: int, message: str | None = None, *args: str, **kwargs: str) -> None:
    """
    Exit invoke with the passed ``exitcode``. Optionally write a message.
    """
    if message is not None:
        if exitcode > 0:
            warn(message, *args, **kwargs)
        else:
            info(message, *args, **kwargs)
    sys.exit(exitcode)


def info(message: str, *args: str, **kwargs: str) -> None:
    """
    Write an information message.
    """
    if not isinstance(message, str):
        message = str(message)
    message = message.format(*args, **kwargs)
    if terminal:
        message = terminal.bold(terminal.green(message))
    write_message(message)


def warn(message: str, *args: str, **kwargs: str) -> None:
    """
    Write a warning message.
    """
    if not isinstance(message, str):
        message = str(message)
    message = message.format(*args, **kwargs)
    if terminal:
        message = terminal.bold(terminal.yellow(message))
    write_message(message)


def error(message: str, *args: str, **kwargs: str) -> None:
    """
    Write an error message.
    """
    if not isinstance(message, str):
        message = str(message)
    message = message.format(*args, **kwargs)
    if terminal:
        message = terminal.bold(terminal.red(message))
    write_message(message)


def write_message(message: str) -> None:
    """
    Write a message to ``sys.stderr``.
    """
    sys.stderr.write(message)
    if not message.endswith("\n"):
        sys.stderr.write("\n")
    sys.stderr.flush()
