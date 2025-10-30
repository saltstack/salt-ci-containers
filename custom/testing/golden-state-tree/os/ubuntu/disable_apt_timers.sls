# disable_apt_timers.sls
{% set apt_units = [
    "apt-daily.service",
    "apt-daily.timer",
    "apt-daily-upgrade.service",
    "apt-daily-upgrade.timer",
] %}

stop_apt_daily_units:
  service.dead:
    - names:
      - apt-daily.service
      - apt-daily-upgrade.service
    - enable: False
    - order: last

stop_apt_daily_timers:
  service.dead:
    - names:
      - apt-daily.timer
      - apt-daily-upgrade.timer
    - enable: False
    - require:
      - service: stop_apt_daily_units

{% for unit in apt_units %}
/etc/systemd/system/{{unit}}:
  file.symlink:
    - target: /dev/null
{% endfor %}
