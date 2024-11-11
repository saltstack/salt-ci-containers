{%- if python_version is not defined %}
  {%- set python_version = '3.10.15' %}
{%- endif %}
{%- if python_prefix is not defined %}
  {%- set python_prefix = '/usr/local' %}
{%- endif %}

include:
{%- if grains['os'] == 'Rocky' %}
  - ./rocky_dependencies
{%- endif %}

python_source_archive:
  file.managed:
    - name: /tmp/Python-{{ python_version }}.tar.xz
    - source: https://www.python.org/ftp/python/{{ python_version }}/Python-{{ python_version }}.tar.xz
    - skip_verify: True

python_source:
  archive.extracted:
    - name: /tmp
    - source: /tmp/Python-{{ python_version }}.tar.xz
    - if_missing: /tmp/Python-{{ python_version }}
    - require:
      - python_source_archive

configure_python:
  cmd.run:
    - name: ./configure --enable-optimizations --prefix={{ python_prefix }}
    - cwd: /tmp/Python-{{ python_version }}
    - creates: /tmp/Python-{{ python_version }}/Makefile
    - require:
      - python_source
      - python_dependencies

make_python:
  cmd.run:
    - name: make
    - cwd: /tmp/Python-{{ python_version }}
    - creates: /tmp/Python-{{ python_version }}/python
    - require:
      - configure_python

install_python:
  cmd.run:
    - name: make install
    - cwd: /tmp/Python-{{ python_version }}
    - creates: {{ python_prefix}}/bin/python{{ python_version.rsplit('.', 1)[0] }}
    - require:
      - make_python
