FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=student

# 將 SQL 腳本複製到初始化目錄
COPY init.sql /docker-entrypoint-initdb.d/

RUN echo "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;" > /docker-entrypoint-initdb.d/init-auth.sql