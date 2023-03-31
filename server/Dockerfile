FROM node:latest
WORKDIR /usr/app

COPY ./src/package.json .
RUN npm install

COPY ./src/index.js .

RUN mkdir models
COPY ./models/* ./models

CMD mkdir uploads

ENTRYPOINT [ "node", "index.js" ]