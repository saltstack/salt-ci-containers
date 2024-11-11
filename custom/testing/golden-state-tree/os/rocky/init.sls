include:
  - .config
  - .pkgs
  - download.vault
  - python

{#
  {%- if pillar.get('github_actions_runner', False) %}
  - github-actions-runner
  {%- endif %}
#}
