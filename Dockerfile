#--------------------------------------------------
# Docker node-red image for raspberry pi
# based on node-red/node-red-docker:rpi
#--------------------------------------------------
FROM nodered/node-red-docker:rpi
MAINTAINER Paulo Costa <coostax@gmail.com>

USER root

#update cache
RUN apt-get update

# Install python and dependencies
RUN apt-get install -y \
    git-core \
    build-essential \
    gcc \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install wiringpi
RUN pip install pyserial
WORKDIR /opt/wiringPi
RUN git clone git://git.drogon.net/wiringPi .
RUN chown -R node-red:node-red /opt/wiringPi
RUN git pull origin && ./build
RUN pip install wiringpi2


# Install python rpi - TODO find way to install documentation
RUN pip install RPi.GPIO

# Install bcm2835 library
WORKDIR /tmp
RUN curl http://www.airspayce.com/mikem/bcm2835/bcm2835-1.56.tar.gz | tar xz
cd bcm2835-1.*
./configure
make
sudo make check
sudo make install



WORKDIR /usr/src/node-red

USER node-red

#install admin script
RUN npm install node-red-admin

# Install additional libs
RUN npm install node-red-contrib-gpio
RUN npm install node-red-contrib-tradfri
RUN npm install node-red-dashboard
RUN npm install node-red-contrib-ifttt
RUN npm install node-red-contrib-google-home-notify
RUN npm install node-red-contrib-slack
RUN npm install node-red-contrib-dht-sensor
RUN npm install node-red-contrib-gpio
RUN npm install node-red-contrib-redis
RUN npm install node-red-node-email
