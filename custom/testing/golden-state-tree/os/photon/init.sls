include:
  - .config
  - .pkgs
  - python-pkgs.nox

/etc/systemd/system/tmp.mount:
  file.symlink:
    - target: /dev/null
    - order: last

set_root_user_no_expiration:
  user.present:
    - name: root
    - expire: -1
    - maxdays: 99999
