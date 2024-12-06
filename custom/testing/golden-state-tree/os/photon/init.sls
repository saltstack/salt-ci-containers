include:
  - .config
  - .pkgs

install_nox:
  cmd.run:
    - name: pip3 --root-user-action=ignore install nox
    - require:
      - python3-pip
