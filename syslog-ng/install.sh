#!/bin/bash

# install syslog-ng
#ansible new-prod-slave -m shell -a "yum install syslog-ng -y"

# rsync syslog-ng config
# ansible new-prod-slave -m synchronize -a "src=/data/deploy/ry/v8/servers_cfg/syslog-ng/ dest=/data/servers_cfg/syslog-ng/"

# link file for syslog-ng and create apps directory
#ansible new-prod-slave -m shell -a "mv /etc/syslog-ng/syslog-ng.conf{,.backup}"
#ansible new-prod-slave -m file -a "src=/data/servers_cfg/syslog-ng/syslog-ng.conf dest=/etc/syslog-ng/syslog-ng.conf state=link"      
#ansible new-prod-slave -m file -a "path=/data/logs-app-combine/apps/ state=directory"      

# start syslog-ng
# ansible new-prod-slave -m systemd -a "name=syslog-ng state=started"
ansible new-prod-slave -m systemd -a "name=syslog-ng state=restarted"

# stop syslog-ng
# ansible new-prod-slave -m systemd -a "name=syslog-ng state=stopped"
