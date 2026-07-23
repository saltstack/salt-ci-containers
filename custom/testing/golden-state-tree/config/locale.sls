# Arch Linux on some clouds has a default encoding of ASCII
# This is not typical in production, so set this to UTF-8 instead
#
# This will cause integration.shell.matcher.MatchTest.test_salt_documentation_arguments_not_assumed
# to fail if not set correctly.
{%- set on_docker = salt['grains.get']('virtual_subtype', '') in ('Docker',) %}
{%- set on_arch = grains['os_family'] == 'Arch' %}
{%- set on_suse = grains['os_family'] in ('Suse', 'SUSE') %}

{%- if grains['os'] in ('MacOS',) %}
mac_locale:
  file.blockreplace:
    - name: /etc/profile
    - marker_start: '#------ start locale zone ------'
    - marker_end: '#------ endlocale zone ------'
    - content: |
        export LANG=en_US.UTF-8
    - append_if_not_found: true

{%- elif grains['os'] in ('FreeBSD',) %}
/root/.bash_profile:
  file.managed:
    - user: root
    - group: wheel
    - mode: '0644'

freebsd_locale:
  file.blockreplace:
    - name: /root/.bash_profile
    - marker_start: '#------ start locale zone ------'
    - marker_end: '#------ endlocale zone ------'
    - content: |
        export LANG=en_US.UTF-8
    - append_if_not_found: true
{%- else %}

  {%- if on_suse %}
suse_local:
  pkg.installed:
    - pkgs:
      - glibc-locale
      - dbus-1

    {%- if not on_docker %}
  service.running:
    - name: dbus.socket
    - onlyif: systemctl daemon-reload
    {%- endif %}
  {%- elif grains.os_family == 'Debian' %}
deb_locale:
  file.touch:
    - name: /etc/default/keyboard  # ubuntu is stupid and this file has to exist for systemd-localed to be able to run
  pkg.installed:
    - pkgs:
      - locales
      - console-data
      - dbus
    {%- if grains.get('init') == 'systemd' %}
  service.running:
    - names:
      - dbus.socket
      - systemd-localed.service
    {%- endif %}

  # Ensure the locale is generated and the config file exists before locale.system runs
  # This prevents "list index out of range" errors in Salt's locale module
  {%- if grains['os'] != 'VMware Photon OS' %}
generate_en_US_locale:
  cmd.run:
    - name: |
        echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
        locale-gen en_US.UTF-8
        [ -f /etc/default/locale ] || echo "LANG=en_US.UTF-8" > /etc/default/locale
    - unless: locale -a | grep -i en_US.utf8
    - require:
      - pkg: deb_locale
  {%- endif %}
  {%- endif %}

  {%- if on_arch %}
accept_LANG_sshd:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: AcceptEnv LANG
    {%- if not pillar.get('packer_golden_images_build', False) %}
  service.running:
    - name: sshd
    - listen:
      - file: accept_LANG_sshd
    {%- endif %}
  {%- endif %}

# Fedora and Centos 8
  {%- if grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int != 7 and grains['os'] != 'VMware Photon OS' %}
redhat_locale:
  pkg.installed:
    - name: glibc-langpack-en

  # Ensure /etc/locale.conf exists for modern RedHat families to prevent Salt errors
/etc/locale.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - content: "LANG=en_US.UTF-8\n"
    - unless: grep -q "^LANG=en_US.UTF-8" /etc/locale.conf
    - require:
      - pkg: redhat_locale
  {%- endif %}

# Photon OS 3
  {%- if grains['os'] == 'VMware Photon OS' %}
photon_locale:
  pkg.installed:
    - name: glibc-lang

/etc/locale.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - content: "LANG=en_US.UTF-8\n"
    - unless: grep -q "^LANG=en_US.UTF-8" /etc/locale.conf
    - require:
      - pkg: photon_locale
  {%- endif %}

us_locale:
  locale.present:
    - name: en_US.UTF-8
    - require:
      {%- if grains.os_family == 'Debian' %}
      - pkg: deb_locale
      {%- elif grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int != 7 and grains['os'] != 'VMware Photon OS' %}
      - pkg: redhat_locale
      {%- elif grains['os'] == 'VMware Photon OS' %}
      - pkg: photon_locale
      {%- elif on_suse %}
      - pkg: suse_local
      {%- else %}
      []
      {%- endif %}

  {%- if grains['os_family'] not in ('FreeBSD',) %}
default_locale:
  locale.system:
    - name: en_US.UTF-8
    - require:
      - locale: us_locale
      {%- if grains.os_family == 'Debian' %}
      - cmd: generate_en_US_locale
      {%- elif grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int != 7 and grains['os'] != 'VMware Photon OS' %}
      - file: /etc/locale.conf
      {%- endif %}
  {%- endif %}
{%- endif %}
