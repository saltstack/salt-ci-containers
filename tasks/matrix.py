"""
Generate the build matrix for the GitHub Actions.
"""
from __future__ import annotations

import json
import sys

from invoke import task

from . import utils


@task
def generate(ctx, image, from_workflow=False):
    """
    Generate the container mirrors.
    """
    ctx.cd(utils.REPO_ROOT)
    mirrors_path = utils.REPO_ROOT / "mirrors" / image

    output = []
    for fpath in mirrors_path.glob("*.Dockerfile"):
        output.append(
            {
                "name": f"{mirrors_path.name}:{fpath.stem}",
                "file": str(fpath.relative_to(utils.REPO_ROOT)),
            }
        )

    if from_workflow:
        print(f"::set-output name=dockerinfo::{json.dumps(output)}", flush=True, file=sys.stdout)
    else:
        print(json.dumps(output), flush=True, file=sys.stdout)
