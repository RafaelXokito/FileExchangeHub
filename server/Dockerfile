FROM node:latest
WORKDIR /usr/app

COPY ./package.json .
RUN npm install

COPY ./index.js .

RUN mkdir models
COPY ./models/* ./models

RUN mkdir uploads

ENTRYPOINT [ "node", "index.js" ]