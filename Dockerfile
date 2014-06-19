# confd and supervisord on trusty
FROM markusma/supervisord:trusty

RUN apt-get update \
 && apt-get install -y --no-install-recommends golang git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp \
 && git clone https://github.com/MarkusMattinen/confd \
 && cd confd \
 && mkdir -p gopath/src/github.com/kelseyhightower/ \
 && ln -s ../../../.. gopath/src/github.com/kelseyhightower/confd \
 && GOPATH=$PWD/gopath:$PWD/Godeps/_workspace go build github.com/kelseyhightower/confd \
 && mv confd /usr/local/bin/confd \
 && chmod +x /usr/local/bin/confd \
 && rm -r /tmp/confd

ADD config/etc/confd /etc/confd
ADD config/etc/supervisor/conf.d /etc/supervisor/conf.d
ADD config/init /init

CMD ["/init"]
