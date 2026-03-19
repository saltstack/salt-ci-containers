include:
  - .config
  - .pkgs
  - python-pkgs.nox

/etc/systemd/system/tmp.mount:
  file.symlink:
    - target: /dev/null
    - order: last
