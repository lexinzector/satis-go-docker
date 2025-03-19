# Сборка Satis-Go
FROM golang:1.18 AS builder
RUN go install -v github.com/benschw/satis-go@latest
WORKDIR /go/src/github.com/benschw/satis-go/

# Сборка UI
FROM node AS builder1
RUN mkdir -p /opt/satis-go/admin-ui && \
    wget -qO- https://github.com/benschw/satis-admin/archive/master.tar.gz | \
        tar xzv --strip-components=1 -C /opt/satis-go/admin-ui
WORKDIR /opt/satis-go/admin-ui
RUN npm i bower --only=prod && \
    node_modules/.bin/bower i --allow-root

# Основной образ
FROM composer/satis

ENV SATIS_GO_BIND="0.0.0.0:8080"
ENV SATIS_GO_DB_PATH="/opt/satis-go/data"
ENV SATIS_GO_REPOUI_PATH="/usr/share/nginx/html"
ENV SATIS_GO_REPO_NAME="My Satis"
ENV SATIS_GO_REPO_HOST="http://localhost:8080"
ENV PATH="/satis/bin:${PATH}"
ENV LANG="C.UTF-8"
ENV TINI_VERSION="v0.18.0"

# Установка glibc из Alpine без сторонних репозиториев
RUN apk add --no-cache gcompat

# Установка tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Установка satis-go
RUN mkdir -p /opt/satis-go /opt/satis-go/admin-ui
COPY --from=builder /go/bin/satis-go /opt/satis-go/
RUN chmod +x /opt/satis-go/satis-go && \
    wget -qO- https://github.com/benschw/satis-admin/releases/download/0.1.1/admin-ui.tar.gz | \
        tar xzv --strip-components=1 -C /opt/satis-go/admin-ui
COPY --from=builder1 /opt/satis-go/admin-ui/bower_components /opt/satis-go/admin-ui/bower_components

# Копирование конфигурации и скриптов
ADD entrypoint.sh /entrypoint.sh
ADD config.template.yaml /opt/satis-go/config.template.yaml

EXPOSE 8080

ENTRYPOINT ["/tini", "-g", "--", "/entrypoint.sh"]

CMD ["/opt/satis-go/satis-go"]
