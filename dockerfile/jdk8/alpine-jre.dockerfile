FROM myalpine:1.0.2

ENV LANG=en_US.UTF-8 \
    JRE_TAR="jre-8u341-linux-x64.tar.gz" \
    JRE_HOME=/usr/local/jre1.8.0_341 \
    CLASSPATH=.:/usr/local/jre1.8.0_341/lib \
    PATH=/usr/local/jre1.8.0_341/bin:$PATH

RUN apk update \
    && apk --no-cache add java-cacerts \
    && cd /tmp/ \
    && wget http://192.168.1.73:8888/${JRE_TAR} \
    && tar -zxvf ${JRE_TAR} -C /usr/local/ \
    && rm -rf ${JRE_TAR} \
    && ln -sf /etc/ssl/certs/java/cacerts ${JRE_HOME}/lib/security/cacerts \
    && rm -rf /tmp/* /var/cache/apk/* \
        /usr/local/jre1.8.0_341/plugin \
        /usr/local/jre1.8.0_341/bin/javaws \
        /usr/local/jre1.8.0_341/bin/orbd \
        /usr/local/jre1.8.0_341/bin/pack200 \
        /usr/local/jre1.8.0_341/bin/policytool \
        /usr/local/jre1.8.0_341/bin/rmid \
        /usr/local/jre1.8.0_341/bin/rmiregistry \
        /usr/local/jre1.8.0_341/bin/servertool \
        /usr/local/jre1.8.0_341/bin/tnameserv \
        /usr/local/jre1.8.0_341/bin/unpack200 \
        /usr/local/jre1.8.0_341/lib/javaws.jar \
        /usr/local/jre1.8.0_341/lib/deploy* \
        /usr/local/jre1.8.0_341/lib/desktop \
        /usr/local/jre1.8.0_341/lib/*javafx* \
        /usr/local/jre1.8.0_341/lib/*jfx* \
        /usr/local/jre1.8.0_341/lib/amd64/libdecora_sse.so \
        /usr/local/jre1.8.0_341/lib/amd64/libprism_*.so \
        /usr/local/jre1.8.0_341/lib/amd64/libfxplugins.so \
        /usr/local/jre1.8.0_341/lib/amd64/libglass.so \
        /usr/local/jre1.8.0_341/lib/amd64/libgstreamer-lite.so \
        /usr/local/jre1.8.0_341/lib/amd64/libjavafx*.so \
        /usr/local/jre1.8.0_341/lib/amd64/libjfx*.so \
        /usr/local/jre1.8.0_341/lib/ext/jfxrt.jar \
        /usr/local/jre1.8.0_341/lib/oblique-fonts \
        /usr/local/jre1.8.0_341/lib/plugin.jar

WORKDIR /data/servers

EXPOSE 8080/tcp
