FROM ruimarinho/bitcoin-core:latest

RUN apt-get update -y \
  && apt-get install -y libminiupnpc-dev \
                        libqrencode-dev \
                        libqt5core5a \
                        libqt5dbus5 \
                        libqt5gui5 \
                        libqt5network5 \
                        libqt5widgets5 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh

ENV DISPLAY=:0
ENV QT_GRAPHICSSYSTEM="native"

CMD ["bitcoin-qt"]
