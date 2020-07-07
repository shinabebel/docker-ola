FROM ubuntu:18.04

ENV OLA_GIT=https://github.com/OpenLightingProject/ola
ENV OLA_VER=0.10.7

ADD start.sh /start.sh
ADD supervisord.conf /etc/supervisord.conf

RUN apt-get update &&\
    apt-get -y dist-upgrade &&\
    apt-get -y install \
    libcppunit-dev libcppunit-1.14-0 uuid-dev pkg-config libncurses5-dev \
    libtool autoconf automake g++ libmicrohttpd-dev libmicrohttpd12 \
    protobuf-compiler libprotobuf-lite10 python-protobuf libprotobuf-dev \
    libprotoc-dev zlib1g-dev bison flex make libftdi-dev libftdi1 \
    libusb-1.0-0-dev liblo-dev libavahi-client-dev python-numpy \
    avahi-daemon supervisor wget &&\
    cd /tmp &&\
    wget ${OLA_GIT}/releases/download/${OLA_VER}/ola-${OLA_VER}.tar.gz &&\
    tar -zxf ola-${OLA_VER}.tar.gz &&\
    cd ola-${OLA_VER} &&\
    autoreconf -i &&\
    ./configure \
        --enable-python-libs \
        --disable-all-plugins \
        --enable-artnet \
        --enable-osc \
        --disable-root-check &&\
    make -j 2 &&\
    make install &&\
    ldconfig &&\
    cd / &&\
    mkdir -p /var/log/supervisord &&\
    mkdir -p /scripts &&\
    apt-get autoremove && apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    chmod a+x /start.sh

EXPOSE 9090

ENTRYPOINT ["/start.sh"]
