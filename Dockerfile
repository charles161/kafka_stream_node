FROM ubuntu:18.04

RUN  apt-get update -qqy \
  && apt-get install -y --no-install-recommends \
     build-essential \
     node-gyp \
     nodejs-dev \
     libssl1.0-dev \
     liblz4-dev \
     libpthread-stubs0-dev \
     libsasl2-dev \
     libsasl2-modules \
     make \
     python \
     nodejs npm ca-certificates \
  && rm -rf /var/cache/apt/* /var/lib/apt/lists/*


RUN mkdir -p /usr/src/poco
WORKDIR /usr/src/poco
COPY package.json /usr/src/poco/
RUN npm install
COPY index.js /usr/src/poco/
COPY index.cons.js /usr/src/poco/
COPY pm2.config.js /usr/src/poco/
ENV PM2_PUBLIC_KEY 7of45w7xe0y8bai
ENV PM2_SECRET_KEY 9dou692e1qtcds8
# CMD ["pm2-runtime", "pm2.config.js"]
CMD ["node", "index.cons.js"]
# Expose the specified port back to the host machine.
EXPOSE 9099




