{%- if grains['os_family'] in ('RedHat', 'Suse')  %}
  {%- set client_pkg = "openssh" -%}
  {%- set server_pkg = "openssh-server" -%}
{%- else %}
  {%- set client_pkg = "openssh-client" -%}
  {%- set server_pkg = "openssh-server" -%}
{%- endif %}

ssh-client:
  pkg.installed:
    - name: {{ client_pkg }}

ssh-server:
  pkg.installed:
    - name: {{ server_pkg }}
