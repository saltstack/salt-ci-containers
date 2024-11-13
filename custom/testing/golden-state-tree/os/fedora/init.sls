include:
  - .config
  - .pkgs
  - python

  {%- if pillar.get('github_actions_runner', False) %}
  - github-actions-runner
  {%- endif %}
