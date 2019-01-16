#!/bin/bash
#this file is used to download bt files
torrent_file=/opt/software/download/deploy.torrent
download_file=/opt/software/download/deploy.tar.gz
local_ip=$(hostname -I|awk '{print $1}')
murder_client_bin=/opt/app/murder/dist/murder_client.py

python  $murder_client_bin peer $torrent_file $download_file $local_ip
