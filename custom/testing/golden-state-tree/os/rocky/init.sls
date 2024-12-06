include:
  - .config
  - .pkgs
  - download.vault

install_nox:
  cmd.run:
    - name: pip3 install nox
    - require:
      - python3-pip
