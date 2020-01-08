FROM busybox
RUN mkdir /tmp/foo
RUN dd if=/dev/zero of=/tmp/foo/bar bs=100M count=1
RUN rm /tmp/foo/bar
