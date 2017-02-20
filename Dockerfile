FROM mono:4.6.2

ENV APTLIST="ca-certificates-mono bzip2 libcurl4-openssl-dev wget unzip sqlite3 python"

# install packages
RUN apt-get update -q && \
    apt-get install $APTLIST -qy && \

    mkdir /app && \
    mkdir /config && \

    curl -o /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz" && \
    tar xfz /tmp/s6-overlay.tar.gz -C / && \

# clean up
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \

    cert-sync /etc/ssl/certs/ca-certificates.crt

# add user 'ombi'
RUN useradd -u 9001 -U -d /config -s /bin/false ombi && usermod -G users ombi

COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 3579

WORKDIR /config

ENTRYPOINT ["/init"]
