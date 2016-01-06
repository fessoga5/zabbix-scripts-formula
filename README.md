.....

How to create new zabbix scripts repo:

1) create git repo with name zabbix-scripts-{{name}}, where {{name}} is program os service, that you want to monitor (for example: zabbix-scripts-mysql, zabbix-scripts-raid and etc)

2) put script in that repo

3) also put there zabbix config with user parameters, that will be included to zabbix main config and name it zabbix-scripts-OBJECT.conf

4) (optional) put file with crontabs job for monitoring, and name it crontab

5) push it to git02 master branch (or ask Artem to merge it your branch to master)

6) configure your pillar

Как использовать zabbix-script-{{name}}:

1) Сначала нужно создать git репозиторий с именем zabbix-scripts-{{name}}. Имя может быть любым, например mysql, raid и др. 

2) Создаем необхидимые скрипты для работы мониторинга.

3) Теперь нужно создать конфиг файл для zabbix. Он должен называться zabbix-scripts-{{name}}.conf в нем ты определяешь необходимые UserParameter.

4) (Опционально) Ты можешь создать файл crontabs в своем репозитории, этот файл в последствии будет применен в crontab.

5) Запушь все изменения в свой репозиторий.

6) Теперь нужно сконфигурировать pillar для твоих скриптов. Смотри pillar.example
