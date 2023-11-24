"""
Tools utilities.
"""
from __future__ import annotations

import os
import pathlib

import yaml

REPO_ROOT = pathlib.Path(__file__).parent.parent


def get_containers():
    """
    Return a list of containers.
    """
    containers_path = REPO_ROOT / "containers.yml"
    if containers_path.exists():
        with containers_path.open("r") as rfh:
            loaded_containers = yaml.safe_load(rfh.read())
    else:
        loaded_containers = {
            "salt": {},
            "custom": {},
            "mirrors": {},
        }

    salt_containers = loaded_containers["salt"]
    custom_containers = loaded_containers["custom"]
    mirror_containers = loaded_containers["mirrors"]
    for name, details in salt_containers.items():
        details["is_mirror"] = False
        details["path"] = "salt"
        salt_containers[name] = details

    for name, details in custom_containers.items():
        details["is_mirror"] = False
        details["path"] = os.path.join("custom", details.get("dest") or details["name"])
        custom_containers[name] = details

    for name, details in mirror_containers.items():
        details["is_mirror"] = True
        if "name" not in details:
            details["name"] = name.lower().replace(" ", "-")
        details["path"] = os.path.join("mirrors", details.get("dest") or details["name"])
        mirror_containers[name] = details

    return list(sorted(salt_containers.items()) + sorted(custom_containers.items())) + list(
        sorted(mirror_containers.items())
    )


def get_source_container(ctx, dockerfile):
    """
    Returns the source container.
    """
    source_container = None
    with dockerfile.open("r") as rfh:
        for line in rfh:
            if line.startswith("FROM "):
                source_container = line.strip().split()[-1]
                break
        else:
            ctx.error("Failed to find 'FROM ' line")
            ctx.exit(1)
    return source_container
