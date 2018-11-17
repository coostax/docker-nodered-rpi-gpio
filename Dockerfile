#--------------------------------------------------
# Docker node-red image for raspberry pi
# based on arm32v7/node:10-slim
# Using build process from node-red-docker/rpi
#--------------------------------------------------
FROM arm32v7/node:10-slim
MAINTAINER Paulo Costa <coostax@gmail.com>

USER root

# Install python and dependencies
RUN apt-get update && apt-get install -y \
    git-core \
    build-essential \
    gcc \
    python-dev \
    python-pip \
    python-virtualenv \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Add node-red user so we aren't running as root.
# Set home director for Node-RED app source
# Set user data directory for flows configs and nodes
RUN mkdir -p /usr/src/node-red && mkdir /data \
  && useradd --home-dir /usr/src/node-red --no-create-home node-red \
  && chown -R node-red:node-red /data \
  && chown -R node-red:node-red /usr/src/node-red

# Install wiringpi and python rpi
WORKDIR /opt/wiringPi
RUN pip install pyserial \
 && git clone git://git.drogon.net/wiringPi .\
 && chown -R node-red:node-red /opt/wiringPi \
 && git pull origin && ./build \
 && pip install wiringpi2 \
 && pip install RPi.GPIO

# Install bcm2835 library
WORKDIR /usr/local/lib
RUN curl http://www.airspayce.com/mikem/bcm2835/bcm2835-1.56.tar.gz | tar xz && \
  cd bcm2835-1.* && \
  ./configure && \
  make && make install

USER node-red

WORKDIR /usr/src/node-red
# Install Node-RED NPM module and node dependencies in package.json
COPY package.json /usr/src/node-red/
RUN npm install && npm install node-red-admin

# User configuration directory volume
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

CMD ["npm", "start", "--", "--userDir", "/data"]
