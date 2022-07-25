"""
Generate the mirrors layout.
"""
from __future__ import annotations

import jinja2.sandbox
import yaml
from invoke import task

from . import utils


@task
def generate(ctx, ghcr_org="s0undt3ch-salt-ci"):
    """
    Generate the container mirrors.
    """
    ctx.cd(utils.REPO_ROOT)
    mirrors_path = utils.REPO_ROOT / "mirrors" / "containers.yml"
    if mirrors_path.exists():
        with mirrors_path.open("r") as rfh:
            mirrors = yaml.safe_load(rfh.read())
    else:
        mirrors = []

    main_readme = utils.REPO_ROOT / "README.md"
    main_readme_contents = []

    for line in main_readme.read_text().splitlines():
        if line == "## Included Containers":
            main_readme_contents.append(line)
            break
        else:
            main_readme_contents.append(line)

    for container_path in sorted(utils.REPO_ROOT.joinpath("custom").glob("*")):
        container_name = container_path.name
        readme = container_path / "README.md"
        readme_contents = []
        for dockerfile in container_path.glob("*.Dockerfile"):
            version = dockerfile.stem
            readme_contents.append(
                f"- {container_name} - `ghcr.io/{ghcr_org}/{container_name}:{version}`"
            )

        with readme.open("w") as wfh:
            header = f"# {container_name} containers\n"
            main_readme_contents.append("\n")
            main_readme_contents.append(f"##{header}")
            main_readme_contents.extend(readme_contents)
            wfh.write(f"{header}\n")
            wfh.write("\n".join(readme_contents))
            wfh.write("\n")

    for name in sorted(mirrors):
        utils.info(f"Generating {name} mirror...")
        container = mirrors[name]["container"]
        if "/" in container:
            org, container_name = container.rsplit("/", 1)
        else:
            org = "_"
            container_name = container

        source_tag = mirrors[name].get("source_tag")
        mirror = utils.REPO_ROOT / "mirrors" / container_name
        mirror.mkdir(parents=True, exist_ok=True)
        readme = mirror / "README.md"
        readme_contents = []
        for version in sorted(mirrors[name]["versions"]):
            utils.info(f"  Generating docker file for version {version}...")
            dockerfile = utils.REPO_ROOT / "mirrors" / container_name / f"{version}.Dockerfile"
            readme_contents.append(
                f"- [{container}](https://hub.docker.com/r/{org}/{container_name}"
                f"/tags?name={source_tag or version}) - `ghcr.io/{ghcr_org}/{container_name}:{version}`"
            )
            with dockerfile.open("w") as wfh:
                wfh.write(f"FROM {container}:{source_tag or version}\n")

        with readme.open("w") as wfh:
            header = f"# {name} mirrored containers\n"
            main_readme_contents.append("\n")
            main_readme_contents.append(f"##{header}")
            main_readme_contents.extend(readme_contents)
            wfh.write(f"{header}\n")
            wfh.write("\n".join(readme_contents))
            wfh.write("\n")

        utils.info(f"  Generating Github workflow for {name} mirror...")
        env = jinja2.sandbox.SandboxedEnvironment()
        workflow_tpl = utils.REPO_ROOT / ".github" / "workflows" / ".mirror.template.j2"
        template = env.from_string(workflow_tpl.read_text())
        jinja_context = {
            "name": name,
            "dockerfiles_path": mirror.relative_to(utils.REPO_ROOT),
            "repository_owner": ghcr_org,
            "repository_path": container_name,
        }
        workflow_path = utils.REPO_ROOT / ".github" / "workflows" / f"{container_name}.yml"
        workflow_path.write_text(template.render(**jinja_context).rstrip() + "\n")

    main_readme_contents[-1] = main_readme_contents[-1].rstrip()
    main_readme_contents.append("\n")

    with main_readme.open("w") as wfh:
        contents = "\n".join(main_readme_contents).rstrip()
        wfh.write(f"{contents}\n")

    ctx.run("git add mirrors/ .github/workflows/*.yml")
