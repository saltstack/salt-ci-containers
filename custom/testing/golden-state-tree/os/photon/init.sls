include:
  - .config
  - .pkgs

install_nox:
  cmd.run:
    - name: pip3 install nox
    - require:
      - python3-pip
    - env:
       - PIP_ROOT_USER_ACTION: ignore

/etc/systemd/system/tmp.mount:
  file.symlink:
    - target: /dev/null
    - order: last
