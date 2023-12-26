#!/bin/bash
set -e

function getHostname()
{
  local HOST=''

  while test -z "$HOST"
  do
    read -p "$1 : " HOST
  done

  echo $HOST;
}

SETUP_MASTER_SCRIPT='
rabbitmqctl stop_app;
rabbitmqctl reset;
rabbitmqctl start_app;
';

# Step 1 : Setup the Master. Get the erlang cookie

echo "Setup RabbitMQ Master";
echo "=====================";

OUT=/tmp/master.out
MASTER_HOSTNAME=$(getHostname "Enter the master server's hostname");
echo "[$MASTER_HOSTNAME] Setting up master";
ssh -t $MASTER_HOSTNAME "bash -c '$SETUP_MASTER_SCRIPT cat /var/lib/rabbitmq/.erlang.cookie;'" | tee $OUT;
COOKIE=$(cat $OUT | tail -n1)
rm $OUT;
echo "Master's Erlang Cookie : '$COOKIE'"

MASTER_IP=$(getHostname "Enter the master server's IP as seen from the slaves (Use a local IP if available)");


# Step 2 : Setup the slaves

SETUP_SLAVE_SCRIPT="
sed -i \"s/^$/$MASTER_IP    $MASTER_HOSTNAME\n/\" /etc/hosts
bash -c \"echo -n '$COOKIE' > /var/lib/rabbitmq/.erlang.cookie\";
rabbitmqctl stop_app;
rabbitmqctl reset;
rabbitmqctl join_cluster --ram rabbit@$MASTER_HOSTNAME;
rabbitmqctl start_app;
rabbitmqctl cluster_status;
";

echo "Setup RabbitMQ Slaves";
echo "=====================";

SERVER=$(getHostname "Enter slave's hostname or 'q' to quit");
while test "$SERVER" != "q"
do
  echo "Setting up slave";
  echo "ssh '$SERVER'";
  ssh -t $SERVER "bash -c '$SETUP_SLAVE_SCRIPT'";
  SERVER=$(getHostname "Enter another slave's hostname or 'q' to quit");
done

# Step 3 : Create admin user
echo "[$MASTER_HOSTNAME] Setting up admin user";
ssh -t $MASTER_HOSTNAME "bash -c 'rabbitmqctl add_user admin password'";
ssh -t $MASTER_HOSTNAME "bash -c 'rabbitmqctl set_user_tags admin administrator'";
ssh -t $MASTER_HOSTNAME "bash -c 'rabbitmqctl set_permissions -p / admin \".*\" \".*\" \".*\"'";

# Step 3 : Delete guest user
echo "[$MASTER_HOSTNAME] Removing user";
ssh -t $MASTER_HOSTNAME "bash -c 'rabbitmqctl delete_user guest'";

# Step 5 : Create sync policy
echo "[$MASTER_HOSTNAME] Synchronizing cluster";
ssh -t $MASTER_HOSTNAME $"bash -c 'rabbitmqctl set_policy -p / ha-all \"\" '\''{\"ha-mode\":\"all\",\"ha-sync-mode\":\"automatic\"}'\'''";

echo "Done";