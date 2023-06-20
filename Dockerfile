FROM docker.io/nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
COPY ./files /usr/share/nginx/html/files
COPY ./styles.css /usr/share/nginx/html/styles.css
