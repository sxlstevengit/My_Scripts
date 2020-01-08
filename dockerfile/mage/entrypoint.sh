#!/bin/sh

cat > /etc/nginx/conf.d/www.conf << EOF
server {
	server_name $HOSTNAME;
        listen ${ip:-0.0.0.0}:${port:-81};
        root ${NGX_WEB_ROOT};
}
EOF
exec "$@"
