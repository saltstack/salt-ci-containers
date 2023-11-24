from __future__ import annotations

import logging
import pathlib

import ptscripts
from ptscripts.parser import DefaultRequirementsConfig


REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
DEFAULT_REQS_CONFIG = DefaultRequirementsConfig(
    requirements_files=[REPO_ROOT / "requirements.txt"],
)

ptscripts.set_default_requirements_config(DEFAULT_REQS_CONFIG)

ptscripts.register_tools_module("tools.ci")
ptscripts.register_tools_module("tools.pre_commit")

for name in ("boto3", "botocore", "urllib3"):
    logging.getLogger(name).setLevel(logging.INFO)
