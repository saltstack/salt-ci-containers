{%- if grains['os_family'] == 'Debian' %}
  {%- set rust = 'rustc' %}
{%- else %}
  {%- set rust = 'rust' %}
{%- endif %}

{%- if grains['osarch'] == 'arm64' %}
rust:
  cmd.run:
    - name: >-
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
        | sh -s -- -y --default-toolchain stable --profile minimal
        && ln -sf /root/.cargo/bin/rustc /usr/local/bin/rustc
        && ln -sf /root/.cargo/bin/cargo /usr/local/bin/cargo
    - unless: command -v rustc
{%- else %}
rust:
  pkg.installed:
    - name: {{ rust }}
{%- endif %}
