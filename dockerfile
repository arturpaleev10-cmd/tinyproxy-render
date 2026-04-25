FROM ubuntu:latest

RUN apt-get update && apt-get install -y tinyproxy apache2-utils && rm -rf /var/lib/apt/lists/*

# Создаём файл с пользователем и паролем для Basic Auth
RUN htpasswd -cb /etc/tinyproxy/htpasswd user password

# Исправляем стандартный конфиг Tinyproxy, вместо того чтобы писать новый:
# 1. Меняем порт на 8080
# 2. Разрешаем подключения отовсюду
# 3. Включаем Basic Auth
# 4. Отключаем требование Via (чтобы не ругался)
RUN sed -i 's/^Port .*/Port 8080/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^Allow 127.0.0.1/Allow 0.0.0.0\/0/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#BasicAuth /BasicAuth /' /etc/tinyproxy/tinyproxy.conf && \
    echo "ViaHeader Off" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "PidFile /tmp/tinyproxy.pid" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "LogFile /dev/stdout" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "LogLevel Info" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "MaxClients 100" >> /etc/tinyproxy/tinyproxy.conf

EXPOSE 8080

CMD ["tinyproxy", "-d"]
