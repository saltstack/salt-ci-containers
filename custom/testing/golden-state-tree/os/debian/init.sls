include:
  - .config
  - .pkgs

install_nox:
  cmd.run:
    - name: pip3 --break-system-packages install nox
    - require:
      - python3-pip
