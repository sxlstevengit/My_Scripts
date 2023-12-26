# Install RabbitMQ on CentOS 7

```
sudo yum -y install epel-release
sudo yum -y update
```
## Install Erlang

Download repository

```
wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
```

Add repository

```
sudo rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
```

Install erlang and dependencies
```
sudo yum -y install erlang socat logrotate
```

## Install RabbitMQ

Download RabbitMQ package

```
wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.35/rabbitmq-server-3.8.35-1.el8.noarch.rpm
```

Add signing key

```
sudo rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
```

Install rabbitmq-server

```
sudo rpm -Uvh rabbitmq-server-3.8.35-1.el8.noarch.rpm
```

Start RabbitMQ

```
sudo systemctl start rabbitmq-server
```

Automatically start RabbitMQ at boot time

```
sudo systemctl enable rabbitmq-server
```

## RabbitMQ Config (Optional)

Create rabbitmq conf file at `/etc/rabbitmq/rabbitmq.conf` 

```
listeners.ssl.default = 5671

ssl_options.cacertfile = /path/to/cacertfile.pem
ssl_options.certfile   = /path/to/certfile.pem
ssl_options.keyfile    = /path/to/keyfile.pem
ssl_options.verify     = verify_peer
ssl_options.versions.1 = tlsv1.2
ssl_options.versions.2 = tlsv1.1
ssl_options.fail_if_no_peer_cert = false

tcp_listen_options.backlog       = 128
tcp_listen_options.nodelay       = true
tcp_listen_options.exit_on_close = false
tcp_listen_options.keepalive     = false

heartbeat = 580
```

## Firewall

If you have a firewall installed and running

```
sudo firewall-cmd --zone=public --permanent --add-port=4369/tcp
sudo firewall-cmd --zone=public --permanent --add-port=25672/tcp
sudo firewall-cmd --zone=public --permanent --add-port=5671-5672/tcp
sudo firewall-cmd --zone=public --permanent --add-port=15672/tcp
sudo firewall-cmd --zone=public --permanent --add-port=61613-61614/tcp
sudo firewall-cmd --zone=public --permanent --add-port=1883/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8883/tcp
```

Reload the firewall

```
sudo firewall-cmd --reload
```

## SELinux

If you have SELinux enabled

```
sudo setsebool -P nis_enabled 1
```

## RabbitMQ Web Management Console

Enable RabbitMQ web management console

```
sudo rabbitmq-plugins enable rabbitmq_management
```

Modify file permissions

```
sudo chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
```

Create an admin user (Change `password` to a strong password)

```
sudo rabbitmqctl add_user admin password
```

Make admin user and administrator

```
sudo rabbitmqctl set_user_tags admin administrator
```

Set admin user permissions

```
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
```

To access the RabbitMQ admin

```
http://Your_Server_IP:15672
```

## RabbitMQ Web Management SSL (Recommended)

Create or update rabbitmq conf file at `/etc/rabbitmq/rabbitmq.conf`

```
management.listener.port = 15672
management.listener.ssl  = true

management.listener.ssl_opts.cacertfile = /path/to/cacertfile.pem
management.listener.ssl_opts.certfile   = /path/to/certfile.pem
management.listener.ssl_opts.keyfile    = /path/to/keyfile.pem
```

## RabbitMQ Cluster

Setup multiple RabbitMQ servers, copy script below to `/usr/local/sbin/rabbitmq-cluster.sh` and run the script