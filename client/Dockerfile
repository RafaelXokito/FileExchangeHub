FROM nginx:latest

COPY build /usr/share/nginx/html

RUN chmod -R 755 /usr/share/nginx/html

COPY ./cmd.sh /docker-entrypoint.d/

RUN chmod +x /docker-entrypoint.d/cmd.sh