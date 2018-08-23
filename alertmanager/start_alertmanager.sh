#!/bin/bash
FDIR=/usr/local/alertmanager
LDIR=/var/log/alertmanager
FLOG=alertmanager.log
nohup ${FDIR}/alertmanager --config.file=${FDIR}/alertmanager.yml >>${LDIR}/${FLOG} 2>&1 &

