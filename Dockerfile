FROM nginx:alpine
COPY index_alternativo.html /usr/share/nginx/html/index.html
EXPOSE 80
