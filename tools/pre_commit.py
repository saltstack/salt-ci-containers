"""
These commands are used by pre-commit.
"""
# pylint: disable=resource-leakage,broad-except,3rd-party-module-not-gated
from __future__ import annotations

import logging
import shutil

import jinja2.sandbox
from ptscripts import command_group
from ptscripts import Context

import tools.utils

log = logging.getLogger(__name__)

# Define the command group
cgroup = command_group(name="pre-commit", help="Pre-Commit Related Commands", description=__doc__)


@cgroup.command(
    name="actionlint",
    arguments={
        "files": {
            "help": "Files to run actionlint against",
            "nargs": "*",
        },
        "no_color": {
            "help": "Disable colors in output",
        },
    },
)
def actionlint(ctx: Context, files: list[str], no_color: bool = False):
    """
    Run `actionlint` against workflows.
    """
    actionlint = shutil.which("actionlint")
    if not actionlint:
        ctx.warn("Could not find the 'actionlint' binary")
        ctx.exit(0)
    cmdline = [actionlint]
    if no_color is False:
        cmdline.append("-color")
    shellcheck = shutil.which("shellcheck")
    if shellcheck:
        cmdline.append(f"-shellcheck={shellcheck}")
    pyflakes = shutil.which("pyflakes")
    if pyflakes:
        cmdline.append(f"-pyflakes={pyflakes}")
    ret = ctx.run(*cmdline, *files, check=False)
    ctx.exit(ret.returncode)


@cgroup.command(
    name="generate-workflows",
    arguments={
        "repository": {
            "help": "The docker repository to use",
        },
    },
)
def generate_workflows(ctx: Context, repository: str = "saltstack/salt-ci-containers"):
    """
    Generate the container mirrors.
    """
    containers = tools.utils.get_containers()

    main_readme = tools.utils.REPO_ROOT / "README.md"
    main_readme_contents = []

    for line in main_readme.read_text().splitlines():
        if line == "<!-- included-containers -->":
            main_readme_contents.append(line)
            main_readme_contents.append("\n## Salt Releases")
            break
        else:
            main_readme_contents.append(line)

    ctx.run(
        "git",
        "rm",
        "-f",
        "mirrors/*/*.Dockerfile",
        ".github/workflows/*-containers.yml",
        check=False,
    )
    for path in tools.utils.REPO_ROOT.joinpath("mirrors").glob("*"):
        if list(path.glob("*")) == [path / "README.md"]:
            ctx.run("git", "rm", "-rf", str(path), check=False)

    custom_headers_included = False
    mirrors_header_included = False
    cron_hour_range = list(range(0, 24))
    for name, details in containers:
        is_mirror = details["is_mirror"]

        if is_mirror:
            if not mirrors_header_included:
                main_readme_contents.append("\n\n## Mirrors")
                mirrors_header_included = True

            ctx.info(f"Generating {name} mirror...")
            container = details["container"]
            if "/" in container:
                org, container_name = container.rsplit("/", 1)
            else:
                org = "_"
                container_name = container

            source_tag = details.get("source_tag")
            container_dir = (
                tools.utils.REPO_ROOT / "mirrors" / (details.get("dest") or details["name"])
            )
            container_dir.mkdir(parents=True, exist_ok=True)
        else:
            org = repository
            container_name = details["name"]
            if details["name"] == "salt":
                container_dir = tools.utils.REPO_ROOT / container_name
            else:
                if not custom_headers_included:
                    main_readme_contents.append("\n## Custom")
                    custom_headers_included = True
                container_dir = tools.utils.REPO_ROOT / "custom" / container_name

        readme = container_dir / "README.md"
        readme_contents = []
        for version in sorted(details["versions"]):
            ctx.info(f"  Generating docker file for version {version}...")
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
                    f"({hosting}) - `ghcr.io/{repository}/{details['name']}:{version}`"
                )
                source_container = f"{container}:{local_source_tag or version}"
                with dockerfile.open("w") as wfh:
                    wfh.write(f"FROM {source_container}\n")
                    for command in details.get("commands", ()):
                        wfh.write(f"RUN {command}\n")
                if not dockerfile_exists:
                    ctx.run("git", "add", str(dockerfile.relative_to(tools.utils.REPO_ROOT)))
            else:
                source_container = tools.utils.get_source_container(ctx, dockerfile)
                readme_contents.append(
                    f"- {container_name}:{version} - `ghcr.io/{repository}/{container_name}:{version}`"
                )

        readme_exists = readme.exists()
        workflow_file_name = f"{details.get('dest') or details['name']}-containers.yml"
        with readme.open("w") as wfh:
            header = (
                f"# [![{name}]"
                f"(https://github.com/{repository}/actions/workflows/{workflow_file_name}/badge.svg)]"
                f"(https://github.com/{repository}/actions/workflows/{workflow_file_name})\n"
            )
            main_readme_contents.append("\n")
            main_readme_contents.append(f"##{header}")
            main_readme_contents.extend(readme_contents)
            wfh.write(f"{header}\n")
            wfh.write("\n".join(readme_contents))
            wfh.write("\n")

        if not readme_exists:
            ctx.run("git", "add", str(readme.relative_to(tools.utils.REPO_ROOT)))

        ctx.info(f"  Generating Github workflow for {name} mirror...")
        env = jinja2.sandbox.SandboxedEnvironment(
            block_start_string="<%",
            block_end_string="%>",
            variable_start_string="<{",
            variable_end_string="}>",
            extensions=[
                "jinja2.ext.do",
            ],
        )
        workflow_tpl = tools.utils.REPO_ROOT / ".github" / "workflows" / ".container.template.j2"
        template = env.from_string(workflow_tpl.read_text())
        cron_hour = cron_hour_range.pop()
        if not cron_hour_range:
            cron_hour_range = list(range(0, 24))
        jinja_context = {
            "name": name,
            "slug": details["name"],
            "repository_path": container_dir.relative_to(tools.utils.REPO_ROOT),
            "is_mirror": is_mirror,
            "workflow_file_name": workflow_file_name,
            "cron_hour": cron_hour,
        }
        workflows_dir = tools.utils.REPO_ROOT / ".github" / "workflows"
        workflow_path = workflows_dir / workflow_file_name
        workflow_path_exists = workflow_path.exists()
        ctx.info(f"  Writing {workflow_path.relative_to(tools.utils.REPO_ROOT)} ...")
        workflow_path.write_text(template.render(**jinja_context).rstrip() + "\n")
        if not workflow_path_exists:
            ctx.run("git", "add", str(workflow_path.relative_to(tools.utils.REPO_ROOT)))

    main_readme_contents[-1] = main_readme_contents[-1].rstrip()
    main_readme_contents.append("\n")

    with main_readme.open("w") as wfh:
        contents = "\n".join(main_readme_contents).rstrip()
        wfh.write(f"{contents}\n")

    ctx.run("git", "add", ".github/workflows/*-containers.yml")
