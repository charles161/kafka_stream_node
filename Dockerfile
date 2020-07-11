FROM node:10.9-alpine

# Create a directory (to house our source files) and navigate to it.
RUN mkdir -p /usr/src/poco
WORKDIR /usr/src/poco
# Installing dockerize which can test and wait on the availability of a TCP host and port.
ENV DOCKERIZE_VERSION v0.6.1
RUN apk add --no-cache openssl \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Installing bash.
RUN apk add --no-cache bash bash-doc bash-completion

# Copy over the package.json and lock file to the containers working directory.
COPY package.json /usr/src/poco/
# Install build dependencies (required for node-gyp), install packages then delete build dependencies.
# This is all done in the same command / layer so when it caches, it won't bloat the image size.
RUN apk add --no-cache --virtual .gyp \
        python \
        make \
        g++ \
    && npm install \
    && apk del .gyp

# Copy everything in the host folder into the working folder of the container.
COPY index.js /usr/src/poco/
COPY index.cons.js /usr/src/poco/
COPY pm2.config.js /usr/src/poco/
ENV PM2_PUBLIC_KEY 7of45w7xe0y8bai
ENV PM2_SECRET_KEY 9dou692e1qtcds8
# CMD ["pm2-runtime", "pm2.config.js"]
CMD ["node", "index.cons.js"]
# Expose the specified port back to the host machine.
EXPOSE 9099