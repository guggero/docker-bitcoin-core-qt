FROM debian:bullseye-slim

LABEL maintainer.0="João Fonseca (@joaopaulofonseca)" \
  maintainer.1="Pedro Branco (@pedrobranco)" \
  maintainer.2="Rui Marinho (@ruimarinho)"

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl \
        gnupg \
        gosu \
        libminiupnpc-dev \
        libqrencode-dev \
        libqt5core5a \
        libqt5dbus5 \
        libqt5gui5 \
        libqt5network5 \
        libqt5widgets5 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG TARGETPLATFORM=linux/amd64
ENV BITCOIN_VERSION=0.21.1
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH

RUN set -ex \
  && if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then export TARGETPLATFORM=x86_64-linux-gnu; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then export TARGETPLATFORM=aarch64-linux-gnu; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm/v7" ]; then export TARGETPLATFORM=arm-linux-gnueabihf; fi \
  && for key in \
    01EA5486DE18A882D4C2684590C8019E36C2E964 \
  ; do \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" || \
      gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
      gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
    done \
  && curl -SLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
  && curl -SLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${BITCOIN_VERSION}-${TARGETPLATFORM}.tar.gz" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

ENV DISPLAY=:0
ENV QT_GRAPHICSSYSTEM="native"

CMD ["bitcoin-qt"]
