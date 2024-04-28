"""
These commands are used by pre-commit.
"""
# pylint: disable=resource-leakage,broad-except,3rd-party-module-not-gated
from __future__ import annotations

import json
import logging
import os
import pathlib
import shutil

from ptscripts import command_group
from ptscripts import Context

import tools.utils

log = logging.getLogger(__name__)

# Define the command group
cgroup = command_group(name="ci", help="CI Related Commands", description=__doc__)


@cgroup.command(
    name="create-manifest-list-and-push",
    arguments={
        "container": {
            "help": "Container name",
        },
        "digests": {
            "help": "Digests path",
        },
    },
)
def create_manifest_list_and_push(ctx: Context, container: str, digests: pathlib.Path):
    """
    Create manifest list and push.
    """
    docker = shutil.which("docker")
    if not docker:
        ctx.warn("Could not find the 'docker' binary")
        ctx.exit(0)
    cmdline = [docker, "buildx", "imagetools", "create"]
    if "DOCKER_METADATA_OUTPUT_JSON" not in os.environ:
        ctx.error("The 'DOCKER_METADATA_OUTPUT_JSON' environment variable is not set")
        ctx.exit(1)

    try:
        data = json.loads(os.environ["DOCKER_METADATA_OUTPUT_JSON"])
    except ValueError:
        ctx.error("Failed to load JSON from the 'DOCKER_METADATA_OUTPUT_JSON' environment variable")
        ctx.exit(1)

    for tag in data["tags"]:
        cmdline.extend(["-t", tag])

    for fpath in digests.iterdir():
        cmdline.append(f"{container}@sha256:{fpath.name}")

    ret = ctx.run(*cmdline)
    ctx.exit(ret.returncode)


@cgroup.command(
    name="matrix",
    arguments={
        "image": {
            "help": "Image name",
        },
        "build_platforms": {
            "help": "The platforms to build. Defaults to 'linux/amd64' and 'linux/arm64/v8' if not passed",
        },
    },
)
def matrix(ctx: Context, image: str, build_platforms: list[str] = None):
    """
    Generate the container mirrors.
    """
    mirrors_path = tools.utils.REPO_ROOT / image

    docker = shutil.which("docker")
    if not docker:
        ctx.warn("Could not find the 'docker' binary")
        ctx.exit(0)

    if build_platforms is None:
        build_platforms = ["linux/amd64", "linux/arm64/v8"]

    for name, details in tools.utils.get_containers():
        if details["path"] == image:
            break
    else:
        ctx.error(f"Failed to find a container matching path {image}")
        ctx.exit(1)
    output = []
    tags = []
    for fpath in mirrors_path.glob("*.Dockerfile"):
        tags.append(fpath.stem)
        if "container" in details:
            source_tag = details.get("source_tag", "{version}").format(version=fpath.stem)
            source_container = f"{details['container']}:{source_tag}"
        else:
            source_container = tools.utils.get_source_container(ctx, fpath)

        ret = ctx.run(
            docker, "buildx", "imagetools", "inspect", "--raw", source_container, capture=True
        )
        data = json.loads(ret.stdout.strip().decode())
        ctx.print(data)
        manifests = data.get("manifests", ())
        if not manifests:
            # This is because the buildx inspect did not return anything
            output.append(
                {
                    "name": details["name"],
                    "tag": fpath.stem,
                    "file": str(fpath.relative_to(tools.utils.REPO_ROOT)),
                    "source_container": source_container,
                    "platform": "",
                    "platform_slug": "all",
                }
            )
        for entry in manifests:
            platform = "{os}/{architecture}".format(**entry["platform"])
            if "variant" in entry["platform"]:
                platform += f"/{entry['platform']['variant']}"
            if platform and platform not in build_platforms:
                continue
            output.append(
                {
                    "name": details["name"],
                    "tag": fpath.stem,
                    "platform": platform,
                    "platform_slug": platform.replace("/", "-"),
                    "file": str(fpath.relative_to(tools.utils.REPO_ROOT)),
                    "source_container": source_container,
                }
            )

    ctx.info("Generated Matrix:")
    ctx.print(output)

    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output is not None:
        with open(github_output, "a", encoding="utf-8") as wfh:
            wfh.write(f"dockerinfo={json.dumps(output)}\n")
            wfh.write(f"tags={json.dumps(tags)}\n")
            wfh.write(f"name={details['name']}")
