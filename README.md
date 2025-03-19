# Satis-Go Docker Image

Этот репозиторий содержит Dockerfile для создания образа Satis-Go — легковесного сервиса для раздачи Composer-пакетов через Satis с веб-интерфейсом.

## 📦 Docker Hub

Образ доступен на Docker Hub:  
[https://hub.docker.com/r/lexinzector/satis-go](https://hub.docker.com/r/lexinzector/satis-go)

## 🚀 Быстрый старт

### Запуск контейнера

```sh
docker run -d \
  -p 8080:8080 \
  -v $(pwd)/satis-data:/opt/satis-go/data \
  --name satis-go \
  lexinzector/satis-go
```

После запуска веб-интерфейс будет доступен по адресу: [http://localhost:8080/admin/](http://localhost:8080/admin/)

### Использование в Docker Compose

Создайте `docker-compose.yml`:

```yaml
version: '3.7'

services:
  satis-go:
    image: lexinzector/satis-go
    container_name: satis-go
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - "satis_data:/opt/satis-go/data"

volumes:
    satis_data:
```

Запустите контейнер:

```sh
docker-compose up -d
```

## 🛠 Конфигурация

Вы можете изменить переменные окружения при запуске контейнера:

| Переменная | Описание | Значение по умолчанию |
|---|---|---|
| `SATIS_GO_BIND` | Адрес и порт для API | `0.0.0.0:8080` |
| `SATIS_GO_DB_PATH` | Путь к базе данных | `/opt/satis-go/data` |
| `SATIS_GO_REPOUI_PATH` | Путь к файлам веб-интерфейса | `/usr/share/nginx/html` |
| `SATIS_GO_REPO_NAME` | Название репозитория | `myvendor/mysatis` |
| `SATIS_GO_REPO_HOST` | URL хоста репозитория | `http://localhost:8080` |
| `GITHUB_TOKEN` | Github токен ([Personal Access Token (PAT)](https://github.com/settings/tokens) с правами `repo`) | |

Пример запуска с кастомным именем репозитория:

```sh
docker run -d -p 8080:8080 -e SATIS_GO_REPO_NAME="customvendor/customrepo" lexinzector/satis-go
```

## 🏗 Сборка образа вручную

Если вам нужно пересобрать образ:

```sh
git clone https://github.com/lexinzector/satis-go-docker.git
cd satis-go-docker
docker build -t lexinzector/satis-go .
```

## 📝 Лицензия

Этот проект распространяется под лицензией MIT.
