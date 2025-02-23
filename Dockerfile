FROM nginx:1.27.3

COPY public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY static.conf /etc/nginx/conf.d/default.conf
