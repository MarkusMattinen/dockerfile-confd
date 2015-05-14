# confd and supervisord on trusty
FROM markusma/supervisord:trusty
MAINTAINER Markus Mattinen <docker@gamma.fi>

RUN apt-get update \
 && apt-get install -y --no-install-recommends golang git \
 && cd /tmp \
 && git clone https://github.com/kelseyhightower/confd -b v0.9.0 \
 && cd confd \
 && mkdir -p gopath/src/github.com/kelseyhightower/ \
 && ln -s ../../../.. gopath/src/github.com/kelseyhightower/confd \
 && GOPATH=$PWD/gopath:$PWD/Godeps/_workspace go build github.com/kelseyhightower/confd \
 && mv confd /usr/local/bin/confd \
 && chmod +x /usr/local/bin/confd \
 && cd / \
 && rm -r /tmp/confd \
 && apt-get purge -y golang git \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD config/etc/confd /etc/confd
ADD config/init /init

CMD ["/init"]
