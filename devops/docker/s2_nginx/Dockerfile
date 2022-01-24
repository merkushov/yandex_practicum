FROM nginx:1.21.5

RUN rm /etc/nginx/conf.d/default.conf
COPY services/s2_nginx/config/nginx.conf /etc/nginx/nginx.conf

# в шаблонах можно использовать переменные окружения
COPY services/s2_nginx/config/templates /etc/nginx/templates