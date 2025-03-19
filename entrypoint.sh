#!/bin/sh

set -e  # Останавливаем выполнение при ошибке

# Подставляем переменные окружения в конфиг
if [ -f /opt/satis-go/config.template.yaml ]; then
    envsubst < /opt/satis-go/config.template.yaml > /opt/satis-go/config.yaml
    echo "[INFO] Config file generated from template."
else
    echo "[ERROR] Config template not found!"
    exit 1
fi

# Проверяем, установлен ли GITHUB_TOKEN
if [ -n "$GITHUB_TOKEN" ]; then
    echo "[INFO] Configuring Git to use HTTPS instead of SSH for GitHub..."
    git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "git@github.com:"

    if [ -f /satis/vendor/bin/composer ]; then
        /satis/vendor/bin/composer config -g github-oauth.github.com "$GITHUB_TOKEN"
        echo "[INFO] Composer configured with GitHub token."
    else
        echo "[WARNING] Composer not found, skipping GitHub token configuration."
    fi
fi


# Запускаем переданную команду (satis-go по умолчанию)
exec /opt/satis-go/satis-go -config /opt/satis-go/config.yaml "$@"
