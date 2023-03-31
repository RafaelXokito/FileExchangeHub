FROM node:latest
WORKDIR /usr/app

COPY src/package.json .
RUN npm install

COPY src/index.js .

ENTRYPOINT [ "node", "index.js" ]