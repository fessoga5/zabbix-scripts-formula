# vim: sts=2 ts=2 sw=2 et ai
{% from "zabbix-scripts/map.jinja" import zabbixlookup with context %}
{% set zabbixpillar = pillar.get("zabbix-scripts").repos %}

zabbix-scripts-formula_git:
  pkg.installed:
    - pkgs:
      {%- for pkg in zabbixlookup.pkgs %}
      - {{pkg}}
      {%- endfor %}


{% for repo,value in zabbixpillar.items() | default([]) %}

zabbix-{{repo}}:
  file.directory:
    - name: /etc/zabbix/scripts/{{ repo }}
    - user: {{ value.user|default('zabbix') }} 
    - mode: 775
    - makedirs: True
  git.latest:
    - name: {{ path | default( zabbixlookup.repopath ~ "/zabbix-scripts-" ~ repo ~ ".git" ) }}
    - rev: master 
    - target: /etc/zabbix/scripts/{{ repo }} 
    - user: {{ value.user|default('zabbix') }} 

{% if value.config is defined %}
{% for name_config, data in value.config.iteritems()|default([]) %}
zabbix-scripts_{{name_config}}:
  file.managed:
    - name: /etc/zabbix/scripts/{{ repo }}/{{name_config}}
    - user: {{ value.user|default('zabbix') }}
    - source: salt://zabbix-scripts/files/config.tmpl
    - mode: 775
    - template: jinja
    - context: 
        data:
          {% for item in data.split('\n') %}
          - "{{ item }}"
          {% endfor %}
{% endfor %}
{% endif %}

"/etc/zabbix/zabbix_agentd.conf.d/zabbix-scripts-{{repo}}.conf":
  file.symlink:
    - target: "/etc/zabbix/scripts/{{repo}}/zabbix-scripts-{{repo}}.conf"

# add jobs to current root crontab if it is required
"(crontab -u root -l ; echo '# zabbix scripts {{repo}}' ; cat /etc/zabbix/scripts/{{repo}}/crontab) | crontab -u root -":
  cmd.run:
    - user: root
    - onlyif: "ls /etc/zabbix/scripts/{{repo}}/crontab"
    - unless: "crontab -l | grep '# zabbix scripts {{repo}}'" 

{% endfor %}
