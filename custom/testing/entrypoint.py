#! env python3
"""
Systemd entrypoint hack.

Writes /cmd.sh from the arguments passed to the script. Then execve systemd so
systemd will be process 1. The target rescue will execute /cmd.sh using /bin/sh.
This is needed so our ENTRYPOINT can be systemd with a target and CMD can be
customized at runtime as expected.
"""
from __future__ import annotations

import os
import sys

with open("/cmd.sh", "w") as fp:
    fp.write(" ".join(sys.argv[1:]))
os.environ["PYTHONPATH"] = os.pathsep.join(sys.path)
cmd = "/usr/lib/systemd/systemd"
if os.execve in os.supports_fd:
    with open(cmd, "rb") as fp:
        sys.stdout.flush()
        sys.stderr.flush()
        args = ["--systemd", "--unit=rescue.target"]
        os.execve(fp.fileno(), args, os.environ)
else:
    args = [cmd, "--systemd", "--unit=rescue.target"]
    os.execve(cmd, args, os.environ)
