{%- if grains['os_family'] == 'Suse' and grains.get('osmajorrelease', 0)|int >= 16 %}
openssl:
  pkg.latest:
    - name: openssl-3
{%- else %}
openssl:
  pkg.latest
{%- endif %}
