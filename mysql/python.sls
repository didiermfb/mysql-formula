{%- set saltpath = salt['grains.get']('saltpath') -%}

{% if "/opt/saltstack/salt" in saltpath %}
mysqlclient_packages:
  pkg.installed:
    - pkgs:
      - libmariadb-dev
      - pkg-config

mysqlclient:
  pip.installed:
    - require:
      - pkg: mysqlclient_packages
{% else %}

{%- from tpldir ~ "/map.jinja" import mysql with context %}

mysql_python_extra_pkg:
  pkg.installed:
#    - name: {{ mysql.pythonpkg }}
    - pkgs: {{ mysql.extra_pkgs|json }}

mysql_python_install:
  pip.installed:
    - name: {{ mysql.pip_pkg }}
    - require:
      - pkg: mysql_python_extra_pkg
{% endif %}
