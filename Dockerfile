FROM node:12-slim
RUN npm install pm2 -g
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/credentials
WORKDIR /usr/src/app
ENV DOCKERIZE_VERSION v0.6.1
COPY package.json /usr/src/app/
RUN npm install
COPY aedes.js /usr/src/app/
COPY ecosystem.config.js /usr/src/app/
EXPOSE 7070 8120 8110
ENV PM2_PUBLIC_KEY 7of45w7xe0y8bai
ENV PM2_SECRET_KEY 9dou692e1qtcds8
CMD ["pm2-runtime", "pm2.config.js"]
VOLUME [ "/usr/src/credentials" ]