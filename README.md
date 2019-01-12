# guggero/bitcoin-core-qt
A bitcoin-core docker image that can run the QT GUI 

[![guggero/bitcoin-core-qt][docker-pulls-image]][docker-hub-url] [![guggero/bitcoin-core-qt][docker-stars-image]][docker-hub-url] [![guggero/bitcoin-core-qt][docker-size-image]][docker-hub-url] [![guggero/bitcoin-core-qt][docker-layers-image]][docker-hub-url]

## Tags

- `latest` ([Dockerfile](https://github.com/guggero/docker-bitcoin-core-qt/blob/master/Dockerfile))

This image uses the latest image of [ruimarinho/bitcoin-core](https://github.com/ruimarinho/docker-bitcoin-core)
and adds the debian dependencies that are necessary to run the QT graphical interface.

## Usage

### How to use this image

To start a X application in docker, some extra steps are necessary:

```sh
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker-xauth

# allow local connections to connect to X server display
xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -
xhost local:

# run the image
docker run -ti \
  --rm \
  -e "XAUTHORITY=${XAUTH}" \
  -v /home/$USER/.bitcoin:/home/bitcoin/.bitcoin \
  -v ${XAUTH}:${XAUTH} \
  -v ${XSOCK}:${XSOCK} \
  guggero/bitcoin-core-qt
```

See [ruimarinho/bitcoin-core](https://github.com/ruimarinho/docker-bitcoin-core)
for more examples.

[docker-hub-url]: https://hub.docker.com/r/guggero/bitcoin-core-qt
[docker-layers-image]: https://img.shields.io/imagelayers/layers/guggero/bitcoin-core-qt/latest.svg?style=flat-square
[docker-pulls-image]: https://img.shields.io/docker/pulls/guggero/bitcoin-core-qt.svg?style=flat-square
[docker-size-image]: https://img.shields.io/imagelayers/image-size/guggero/bitcoin-core-qt/latest.svg?style=flat-square
[docker-stars-image]: https://img.shields.io/docker/stars/guggero/bitcoin-core-qt.svg?style=flat-square
