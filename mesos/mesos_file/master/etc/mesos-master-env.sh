# This file contains environment variables that are passed to mesos-master.
# To get a description of all options run mesos-master --help; any option
# supported as a command-line option is also supported as an environment
# variable.

# Some options you're likely to want to set:
# export MESOS_log_dir=/var/log/mesos

export MESOS_log_dir=/data/logs/mesos
export MESOS_work_dir=/data/mesos
export MESOS_zk=zk://192.168.0.29:2181/mesos
export MESOS_quorum=1
export MESOS_logging_level=INFO
export MESOS_cluster=uat-wcc
export MESOS_ip=192.168.0.29
export MESOS_hostname=192.168.0.29
export MESOS_offer_timeout=60secs
export MESOS_port=5050
