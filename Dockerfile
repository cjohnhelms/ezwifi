FROM docker.io/nginx:latest
COPY ./app/index.html /usr/share/nginx/html/index.html
COPY ./app/files /usr/share/nginx/html/files
COPY ./app/styles.css /usr/share/nginx/html/styles.css

EXPOSE 8000
