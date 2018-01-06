# Node-RED RPI Docker with GPIO access
Node-RED docker container tailored for raspberry pi with GPIO support.

## About
Installs Node-RED for raspberry pi with GPIO support in a docker container.
Is based on rpi version of [node-red/node-red-docker](https://github.com/node-red/node-red-docker) project and adds support for GPIO access and additional packages.


The following packages are included in Node-RED
- node-red-contrib-gpio
- node-red-contrib-tradfri
- node-red-dashboard
- node-red-contrib-google-home-notify
- node-red-contrib-ifttt

## Install

This project has an automated build on [DockerHub](https://hub.docker.com/r/coostax/nodered-rpi-gpio/). You can pull the image with `docker pull coostax/nodered-rpi-gpio`


You can also clone this project and build the image locally

```bash
 docker build -t coostax/nodered-rpi-gpio .
```

## Running

After building the image you can start a container runnning

```bash
docker run -i -t --privileged --device /dev/ttyAMA0:/dev/ttyAMA0 --device /dev/mem:/dev/mem -p 1880:1880 --name=nodered-rpi-gpio coostax/nodered-rpi-gpio
```

### Using the Makefile

It is also possible start a container and build the image in a single step using the provided Makefile
```bash
  make up
```

To stop and remove the container
```bash
  make stop
```

To see more options for the Makefile run `make`

