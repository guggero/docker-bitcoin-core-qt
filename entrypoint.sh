#!/bin/sh
set -e

XDG_RUNTIME_DIR=$(mktemp -d /tmp/service-bitcoin.XXX)
chown bitcoin:bitcoin $XDG_RUNTIME_DIR
export XDG_RUNTIME_DIR

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bitcoin-qt"

  set -- bitcoin-qt "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "bitcoin-qt" ]; then
  mkdir -p "$BITCOIN_DATA"
  chmod 700 "$BITCOIN_DATA"
  chown -R bitcoin "$BITCOIN_DATA"

  echo "$0: setting data directory to $BITCOIN_DATA"

  set -- "$@" -datadir="$BITCOIN_DATA"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ] || [ "$1" = "bitcoin-qt" ]; then
  echo 
  exec gosu bitcoin "$@"
fi

echo
exec "$@"
