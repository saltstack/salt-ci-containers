# python3-xml is included in python3-base on Leap 15; not available on Leap 16+
{%- if grains['osrelease'].startswith('15') %}
python3-base:
  pkg.installed
{%- else %}
python3-xml-noop:
  test.noop
{%- endif %}
