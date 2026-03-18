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

set_root_user_no_expiration:
  user.present:
    - name: root
    - expire: -1
    - maxdays: 99999
