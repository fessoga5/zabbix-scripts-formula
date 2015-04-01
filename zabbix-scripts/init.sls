# vim: sts=2 ts=2 sw=2 et ai
{% from "zabbix-scripts/map.jinja" import zabbixscripts with context %}

zabbix-scripts-formula_git:
  pkg.installed:
    - pkgs:
      - git 
      - python-yaml

"/etc/zabbix/scripts/incl.sh":
  file.managed:
    - source: salt://zabbix-scripts/files/incl.sh
    - user: root
    - group: root
    - mode: 775
    - makedirs: True
    - template: jinja
    - context:
        data: {{ zabbixscripts.get("include",[]) }}
        bash: {{ zabbixscripts.bash }}

{% for repo,value in zabbixscripts.repos.iteritems()|default([]) %}

zabbix-{{repo}}:
  file.directory:
    - name: /etc/zabbix/scripts/{{ repo }}
    - user: {{ value.user|default('zabbix') }} 
    - mode: 775
    - makedirs: True
  git.latest:
    - name: {{ value.repopath | default("ssh://gitolite@git02.core.irknet.lan") }}/zabbix-scripts-{{repo}}.git
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
"(crontab -u root -l ; echo '#{{repo}}' ; cat /etc/zabbix/scripts/{{repo}}/crontab) | crontab -u root -":
  cmd.run:
    - user: root
    - onlyif: "ls /etc/zabbix/scripts/{{repo}}/crontab"
    - unless: "crontab -l | grep '#{{repo}}'" 

{% endfor %}
