FROM node:12.18.2
# ENV DOCKERIZE_VERSION v0.6.1
# RUN apk add --no-cache openssl \
#     && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#     && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#     && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
# RUN apk add --no-cache bash bash-doc bash-completion
RUN npm install pm2 -g
RUN mkdir -p /usr/src/poco
WORKDIR /usr/src/poco
COPY package.json /usr/src/poco/
# RUN apk add --no-cache --virtual .gyp \
#         python \
#         make \
#         g++ \
#     && npm install \
#     && apk del .gyp
COPY index.js /usr/src/poco/
COPY pm2.config.js /usr/src/poco/
ENV PM2_PUBLIC_KEY 7of45w7xe0y8bai
ENV PM2_SECRET_KEY 9dou692e1qtcds8
# CMD ["pm2-runtime", "pm2.config.js"]
CMD ["node", "index.js"]