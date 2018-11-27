#!/bin/bash
service cloudera-scm-server stop
service cloudera-scm-server-db stop

service cloudera-scm-agent stop
yum remove cloudera-manager-agent -y

yum remove cloudera-manager-server -y
yum remove cloudera-manager-server-db -y

yum remove -y 'cloudera-manager-*' bigtop-utils bigtop-jsvc bigtop-tomcat hadoop hadoop-hdfs hadoop-httpfs hadoop-mapreduce hadoop-yarn hadoop-client hadoop-0.20-mapreduce hue-plugins hbase hive oozie oozie-client pig zookeeper hue impala impala-shell solr-server

yum remove -y 'cloudera-manager-*' avro-tools crunch flume-ng hadoop-hdfs-fuse hadoop-hdfs-nfs3 hadoop-httpfs hbase-solr hive-hbase hive-webhcat hue-beeswax hue-hbase hue-impala hue-pig hue-plugins hue-rdbms hue-search hue-spark hue-sqoop hue-zookeeper impala impala-shell kite llama mahout oozie pig pig-udf-datafu search sentry solr-mapreduce spark-python sqoop sqoop2 whirr

#sudo zypper remove 'cloudera-manager-*' bigtop-utils bigtop-jsvc bigtop-tomcat hadoop hadoop-hdfs hadoop-httpfs hadoop-mapreduce hadoop-yarn hadoop-client hadoop-0.20-mapreduce hue-plugins hbase hive oozie oozie-client pig zookeeper hue impala impala-shell solr-server

#sudo zypper remove 'cloudera-manager-*' avro-tools crunch flume-ng hadoop-hdfs-fuse hadoop-hdfs-nfs3 hadoop-httpfs hbase-solr hive-hbase hive-webhcat hue-beeswax hue-hbase hue-impala hue-pig hue-plugins hue-rdbms hue-search hue-spark hue-sqoop hue-zookeeper impala impala-shell kite llama mahout oozie pig pig-udf-datafu search sentry solr-mapreduce spark-python sqoop sqoop2 whirr

yum clean all
#sudo zypper remove 'cloudera-manager-*'

for u in cloudera-scm flume hadoop hdfs hbase hive httpfs hue impala llama mapred oozie solr spark sqoop sqoop2 yarn zookeeper; do kill -9 $(ps -U $u -u $u -o pid=); done

umount /var/run/cloudera-scm-agent/process
umount /run/cloudera-scm-agent/process

rm -rf /opt/cloudera/parcels/*
rm -rf /bdata/*
rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera* /var/run/hdfs*
rm -rf /var/lib/kafka /var/lib/kudu /var/lib/sentry /var/lib/yarn-ce
rm -rf /opt/cloudera/cm-agent
rm -rf /opt/cloudera/cm /opt/cloudera/csd

rm /tmp/.scm_prepare_node.lock
rm -Rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper /var/lib/hbase /var/lib/hive /var/lib/impala

rm -Rf /dfs /mapred /yarn

rm -rf /var/log/hadoop* /var/log/hbase /var/log/impalad /var/log/zookeeper /var/cache/yum/x86_64/6/cloudera*
