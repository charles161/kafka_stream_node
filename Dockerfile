FROM node:12-slim
RUN mkdir -p /usr/src/pocon
WORKDIR /usr/src/pocon
COPY package.json /usr/src/pocon/
RUN npm install
COPY producer.js /usr/src/pocon/
COPY pm2.config.js /usr/src/pocon/
ENV PM2_PUBLIC_KEY 7of45w7xe0y8bai
ENV PM2_SECRET_KEY 9dou692e1qtcds8
# CMD ["pm2-runtime", "pm2.config.js"]
CMD ["node", "producer.js"]
# Expose the specified port back to the host machine.
EXPOSE 9099




