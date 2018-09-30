#!/bin/bash
docker run -it --net host --restart=always \
        --name marathon-lb \
        --log-opt max-file=10 --log-opt max-size=20k \
        -e PORTS=8000 \
        -v /data/haproxy/logs:/var/log/:rw \
        --privileged=true \
        marathon-lb:1.0 sse --marathon http://10.20.0.10:8080 http://10.20.0.3:8080 http://10.20.0.15:8080 --group external --health-check
