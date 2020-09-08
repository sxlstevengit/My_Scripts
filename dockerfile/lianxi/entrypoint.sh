#!/bin/sh
cat > /etc/nginx/conf.d/mynginx.conf << EOF
server {
       server_name $HOSTNAME;
       listen ${IP:-0.0.0.0}:${PORT:-80};
       root $NG_WEB_ROOT;
}
EOF
exec "$@"
