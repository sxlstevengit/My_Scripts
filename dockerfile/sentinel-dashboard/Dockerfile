FROM sxlsteven/alpine:jdk1.0.0
LABEL maintainer="steven<sxl_youcun@qq.com>" \
      sentinel_dashborad_ver=1.7.1
ENV SENTINEL_HOME=/usr/local/sentinel-dashboard
RUN mkdir -p ${SENTINEL_HOME} 
COPY sentinel-dashboard.jar ${SENTINEL_HOME}
COPY entrypoint.sh /bin/
WORKDIR $SENTINEL_HOME
VOLUME ["/root/logs/csp/"]
EXPOSE 8080
CMD ["/usr/local/jdk1.8.0_212/bin/java"]
ENTRYPOINT ["/bin/entrypoint.sh"]
