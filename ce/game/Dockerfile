FROM docker.io/nginx:stable-alpine
ENV NGINX_PORT=8080
COPY --chown=nginx:nginx dist /usr/share/nginx/html
COPY --chown=nginx:nginx nginx-default-cfg/*.template /etc/nginx/templates/
