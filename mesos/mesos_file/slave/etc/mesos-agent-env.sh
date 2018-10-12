# This file contains environment variables that are passed to mesos-agent.
# To get a description of all options run mesos-agent --help; any option
# supported as a command-line option is also supported as an environment
# variable.

# You must at least set MESOS_master.

# The mesos master URL to contact. Should be host:port for
# non-ZooKeeper based masters, otherwise a zk:// or file:// URL.
#export MESOS_master=unknown-machine:5050

# Other options you're likely to want to set:
# export MESOS_log_dir=/var/log/mesos
# export MESOS_work_dir=/var/run/mesos
# export MESOS_isolation=cgroups

export MESOS_master=zk://192.168.0.29:2181/mesos
export MESOS_isolation=cgroups/cpu,cgroups/mem
export MESOS_log_dir=/data/logs/mesos
export MESOS_work_dir=/data/mesos
export MESOS_ip=192.168.0.2
export MESOS_containerizers=docker,mesos
export MESOS_executor_registration_timeout=10mins
export MESOS_hostname=192.168.0.2
export MESOS_attributes="uat-java:java;uat-base:base"
