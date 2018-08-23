#!/bin/bash
#FDIR=/usr/local/prometheus
FDIR=/root/src/prometheus/prometheus
LDIR=/var/log/prometheus
FLOG=prometheus.log
nohup ${FDIR}/prometheus --config.file=${FDIR}/prometheus.yml >>${LDIR}/${FLOG} 2>&1 &
#/root/src/prometheus/prometheus/prometheus --config.file=/root/src/prometheus/prometheus/prometheus.yml >>/var/log/prometheus/prometheus.log 2>&1

