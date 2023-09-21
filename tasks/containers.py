"""
Generate the mirrors layout.
"""
from __future__ import annotations

import json
import os
import pprint

import jinja2.sandbox
import yaml
from invoke import task

from . import utils


@task
def generate(ctx, ghcr_org="saltstack/salt-ci-containers"):
    """
    Generate the container mirrors.
    """
    ctx.cd(utils.REPO_ROOT)
    containers = _get_containers()

    main_readme = utils.REPO_ROOT / "README.md"
    main_readme_contents = []

    for line in main_readme.read_text().splitlines():
        if line == "<!-- included-containers -->":
            main_readme_contents.append(line)
            main_readme_contents.append("\n## Salt Releases")
            break
        else:
            main_readme_contents.append(line)

    ctx.run(
        "git rm -f mirrors/*/*.Dockerfile .github/workflows/*-containers.yml", warn=True, hide=True
    )
    for path in utils.REPO_ROOT.joinpath("mirrors").glob("*"):
        if list(path.glob("*")) == [path / "README.md"]:
            ctx.run(f"git rm -rf {path}", warn=True, hide=True)

    custom_headers_included = False
    mirrors_header_included = False
    for name, details in containers:
        is_mirror = details["is_mirror"]

        if is_mirror:
            if not mirrors_header_included:
                main_readme_contents.append("\n\n## Mirrors")
                mirrors_header_included = True

            utils.info(f"Generating {name} mirror...")
            container = details["container"]
            if "/" in container:
                org, container_name = container.rsplit("/", 1)
            else:
                org = "_"
                container_name = container

            source_tag = details.get("source_tag")
            container_dir = utils.REPO_ROOT / "mirrors" / (details.get("dest") or details["name"])
            container_dir.mkdir(parents=True, exist_ok=True)
        else:
            org = ghcr_org
            container_name = details["name"]
            if details["name"] == "salt":
                container_dir = utils.REPO_ROOT / container_name
            else:
                if not custom_headers_included:
                    main_readme_contents.append("\n## Custom")
                    custom_headers_included = True
                container_dir = utils.REPO_ROOT / "custom" / container_name

        readme = container_dir / "README.md"
        readme_contents = []
        for version in sorted(details["versions"]):
            utils.info(f"  Generating docker file for version {version}...")
            dockerfile = container_dir / f"{version}.Dockerfile"
            if is_mirror:
                local_source_tag = source_tag
                if local_source_tag is not None:
                    local_source_tag = local_source_tag.format(version=version)
                dockerfile_exists = dockerfile.exists()
                if container.count("/") > 1:
                    hosting = f"https://{org}/{container_name}"
                    if "quay" in org:
                        hosting += f"?tab=tags&tag={local_source_tag or version}"
                else:
                    hosting = f"https://hub.docker.com/r/{org}/{container_name}/tags?name={local_source_tag or version}"
                readme_contents.append(
                    f"- [{org if org != '_' else 'dockerhub'}/{container_name}:{local_source_tag or version}]"
                    f"({hosting}) - `ghcr.io/{ghcr_org}/{details['name']}:{version}`"
                )
                source_container = f"{container}:{local_source_tag or version}"
                with dockerfile.open("w") as wfh:
                    wfh.write(f"FROM {source_container}\n")
                    for command in details.get("commands", ()):
                        wfh.write(f"RUN {command}\n")
                if not dockerfile_exists:
                    ctx.run(f"git add {dockerfile.relative_to(utils.REPO_ROOT)}")
            else:
                source_container = _get_source_container(dockerfile)
                readme_contents.append(
                    f"- {container_name}:{version} - `ghcr.io/{ghcr_org}/{container_name}:{version}`"
                )

        readme_exists = readme.exists()
        workflow_file_name = f"{details.get('dest') or details['name']}-containers.yml"
        with readme.open("w") as wfh:
            header = (
                f"# [![{name}]"
                f"(https://github.com/{ghcr_org}/actions/workflows/{workflow_file_name}/badge.svg)]"
                f"(https://github.com/{ghcr_org}/actions/workflows/{workflow_file_name})\n"
            )
            main_readme_contents.append("\n")
            main_readme_contents.append(f"##{header}")
            main_readme_contents.extend(readme_contents)
            wfh.write(f"{header}\n")
            wfh.write("\n".join(readme_contents))
            wfh.write("\n")

        if not readme_exists:
            ctx.run(f"git add {readme.relative_to(utils.REPO_ROOT)}")

        utils.info(f"  Generating Github workflow for {name} mirror...")
        env = jinja2.sandbox.SandboxedEnvironment(
            block_start_string="<%",
            block_end_string="%>",
            variable_start_string="<{",
            variable_end_string="}>",
            extensions=[
                "jinja2.ext.do",
            ],
        )
        workflow_tpl = utils.REPO_ROOT / ".github" / "workflows" / ".container.template.j2"
        template = env.from_string(workflow_tpl.read_text())
        exclude_platforms = [
            "linux/s390x",
            "linux/mips64le",
        ]
        exclude_platforms.extend(details.get("exclude_platforms") or [])
        jinja_context = {
            "name": name,
            "slug": details["name"],
            "repository_path": container_dir.relative_to(utils.REPO_ROOT),
            "is_mirror": is_mirror,
            "workflow_file_name": workflow_file_name,
            "multiarch": details.get("multiarch", True),
            "exclude_platforms": ",".join(exclude_platforms),
        }
        workflows_dir = utils.REPO_ROOT / ".github" / "workflows"
        workflow_path = workflows_dir / workflow_file_name
        workflow_path_exists = workflow_path.exists()
        utils.info(f"  Writing {workflow_path.relative_to(utils.REPO_ROOT)} ...")
        workflow_path.write_text(template.render(**jinja_context).rstrip() + "\n")
        if not workflow_path_exists:
            ctx.run(f"git add {workflow_path.relative_to(utils.REPO_ROOT)}")

    main_readme_contents[-1] = main_readme_contents[-1].rstrip()
    main_readme_contents.append("\n")

    with main_readme.open("w") as wfh:
        contents = "\n".join(main_readme_contents).rstrip()
        wfh.write(f"{contents}\n")

    ctx.run("git add .github/workflows/*-containers.yml")


@task
def matrix(ctx, image, from_workflow=False):
    """
    Generate the container mirrors.
    """
    ctx.cd(utils.REPO_ROOT)
    mirrors_path = utils.REPO_ROOT / image

    for name, details in _get_containers():
        if details["path"] == image:
            break
    else:
        utils.error(f"Failed to find a container matching path {image}")
        utils.exit_invoke(1)
    output = []
    for fpath in mirrors_path.glob("*.Dockerfile"):
        if "container" in details:
            source_tag = details.get("source_tag", "{version}").format(version=fpath.stem)
            source_container = f"{details['container']}:{source_tag}"
        else:
            source_container = _get_source_container(fpath)
        output.append(
            {
                "name": f"{details['name']}:{fpath.stem}",
                "file": str(fpath.relative_to(utils.REPO_ROOT)),
                "source_container": source_container,
            }
        )

    utils.info("Generated Matrix:")
    utils.write_message(pprint.pformat(output))

    if from_workflow:
        github_output = os.environ.get("GITHUB_OUTPUT")
        if github_output is None:
            utils.warn("The 'GITHUB_OUTPUT' variable is not set.")
            utils.exit_invoke(1)
        with open(github_output, "a", encoding="utf-8") as wfh:
            wfh.write(f"dockerinfo={json.dumps(output)}\n")


@task
def platforms(ctx, supported_platforms_file, exclude=None):
    """
    Generate a platforms list.
    """
    if exclude is None:
        excludes = []
    else:
        excludes = exclude.split(",")
    platforms = {"linux/amd64"}
    with open(supported_platforms_file, encoding="utf-8") as rfh:
        for line in rfh:
            if "Platform:" in line:
                _, platform = line.split()
                if platform in excludes:
                    utils.info("Excluding {}", platform)
                    continue
                utils.info("Inluding {}", platform)
                platforms.add(platform)

    contents = "platforms={}".format(",".join(sorted(platforms)))
    utils.info("Writing '{}' to $GITHUB_OUTPUT ...", contents)
    with open(os.environ["GITHUB_OUTPUT"], "w", encoding="utf-8") as wfh:
        wfh.write(f"{contents}\n")


def _get_containers():
    containers_path = utils.REPO_ROOT / "containers.yml"
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


def _get_source_container(dockerfile):
    source_container = None
    with dockerfile.open("r") as rfh:
        for line in rfh:
            if line.startswith("FROM "):
                source_container = line.strip().split()[-1]
                break
        else:
            utils.error("Failed to find 'FROM ' line")
            utils.exit_invoke(1)
    return source_container
