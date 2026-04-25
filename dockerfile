FROM ubuntu:latest

RUN apt-get update && apt-get install -y tinyproxy apache2-utils && rm -rf /var/lib/apt/lists/*

# Пользователь прокси
RUN htpasswd -cb /etc/tinyproxy/htpasswd user password

# Минимальный рабочий конфиг Tinyproxy без лишних директив
RUN echo "Port 8080" > /etc/tinyproxy/tinyproxy.conf && \
    echo "Listen 0.0.0.0" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Allow 0.0.0.0/0" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "BasicAuth /etc/tinyproxy/htpasswd" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "DisableViaHeader Yes" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "PidFile /tmp/tinyproxy.pid" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "LogFile /dev/stdout" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "LogLevel Info" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "User root" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Group root" >> /etc/tinyproxy/tinyproxy.conf

EXPOSE 8080

CMD ["tinyproxy", "-d"]
