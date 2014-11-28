.....

How to create new zabbix acripts repo:
1) create git repo on git02 with name zabbix-scripts-OBJECT, where object is program os service, that you want to monitor (for example, mysql, raid, etc)
2) put script in that repo
3) also put there zabbix config with user parameters, that will be included to zabbix main config and name it zabbix-scripts-OBJECT.conf
4) (optional) put file with crontabs job for monitoring, and name it crontab
5) push it to git02 master branch (or ask Artem to merge it your branch to master)
6) configure your pillar
