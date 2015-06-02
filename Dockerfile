FROM shift/ubuntu:15.04
MAINTAINER Vincent Palmer <shift@someone.section.me>

WORKDIR /opt

RUN apt-get update \
    && apt-get upgrade --yes --force-yes \
    && apt-get --yes --force-yes install libpcre3 libpcre3-dbg libpcre3-dev \
       build-essential autoconf automake libtool libpcap-dev libnet1-dev \
       libyaml-0-2 libyaml-dev zlib1g zlib1g-dev make flex bison libmagic-dev \
       libjansson-dev libjansson4 libnss3-dev libnspr4-dev libgeoip1 libgeoip-dev \
       libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev \
       libnfnetlink0  libcap-ng0 libcap-ng-dev oinkmaster ethtool curl cron \
       python-simplejson libluajit-5.1-dev luajit ulogd2 libprelude2 psmisc \
    && curl -O http://www.openinfosecfoundation.org/download/suricata-2.0.8.tar.gz \
    && tar xfvz suricata-2.0.8.tar.gz \
    && cd suricata-2.0.8 \
    && ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \
    --disable-gccmarch-native --with-libnss-libraries=/usr/lib \
    --with-libnss-includes=/usr/include/nss/ --enable-nfqueue \
    --with-libcap_ng-libraries=/usr/local/lib --with-libcap_ng-includes=/usr/local/include \
    --with-libnspr-libraries=/usr/lib \
    --with-libnspr-includes=/usr/include/nspr \
    --with-nflog \
    --with-libluajit \
    && make clean \
    && make \
    && make install-full \
    && ldconfig \
    && apt-get purge --yes --force-yes build-essential \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf /opt/suricata-2.0.8 /opt/suricata-2.0.8.tar.gz

VOLUME /etc/suricata
VOLUME /etc/suricata/rules
VOLUME /var/log/suricata

ADD files/oinkmaster.conf /etc/oinkmaster.conf
ADD files/blacklist.sh /blacklists.sh
ADD files/start.sh /start.sh
RUN chmod u+x /start.sh /blacklists.sh
ENTRYPOINT ["/start.sh"]

