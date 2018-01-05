# Node-RED RPI Docker with GPIO access
Node-RED docker container tailored for raspberry pi with GPIO support.

## About
Installs Node-RED for raspberry pi with GPIO support in a docker container.
Is based on rpi version of [node-red/node-red-docker](https://github.com/node-red/node-red-docker) project and adds support for GPIO access and additional packages.


## Installation

Node-RED is installed for user node-red which is created in the docker initialization

docker build -t coostax/nodered-gpio-rpi-docker:latest .


## Running

docker run --device /dev/ttyAMA0:/dev/ttyAMA0 --device /dev/mem:/dev/mem -p 1880:1880 --privileged -ti coostax/nodered-gpio-rpi-docker
