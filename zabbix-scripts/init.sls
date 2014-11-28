# vim: sts=2 ts=2 sw=2 et ai
{% from "zabbix-scripts/map.jinja" import zabbixscripts with context %}

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

{% for repo in zabbixscripts.get("repos",[]) %}

{{repo}}:
  file.directory:
    - name: /etc/zabbix/scripts/{{ repo }}
    - user: root 
    - mode: 775
    - makedirs: True
  git.latest:
    - name: ssh://gitolite@git02.core.irknet.lan/zabbix-scripts-{{repo}}.git
    - rev: master 
    - target: /etc/zabbix/scripts/{{ repo }} 
    - user: root 

"/etc/zabbix/zabbix_agentd.conf.d/zabbix-scripts-{{repo}}.conf":
  file.symlink:
    - target: "/etc/zabbix/scripts/{{repo}}/zabbix-scripts-{{repo}}.conf"

"crontab -u root /etc/zabbix/scripts/{{repo}}/crontab":
  cmd.run:
    - user: root
    - onlyif: "ls /etc/zabbix/scripts/{{repo}}/crontab"

{% endfor %}
