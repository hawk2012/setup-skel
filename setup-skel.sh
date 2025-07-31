#!/bin/bash
# setup-skel.sh — Настраивает /etc/skel для автоматического создания .ssh/authorized_keys

set -euo pipefail

SKEL_DIR="/etc/skel"
SSH_DIR="$SKEL_DIR/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

echo "Настройка /etc/skel для автоматического создания .ssh/authorized_keys..."

# 1. Создаём директории
mkdir -p "$SSH_DIR"

# 2. Создаём пустой authorized_keys
touch "$AUTH_KEYS"

# 3. Устанавливаем правильные права
chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS"

# 4. Меняем владельца на root (важно для /etc/skel)
chown -R root:root "$SKEL_DIR"
echo "Права установлены: .ssh/ — 700, authorized_keys — 600"

# 5. Проверяем, что useradd использует -m по умолчанию (копирует skel)
# Обычно в /etc/default/useradd уже есть CREATE_HOME=yes

echo "Готово! Теперь при создании пользователя:"
echo "  useradd -m username"
echo "домашний каталог будет включать .ssh/authorized_keys"

# Пример создания пользователя
echo ""
echo "Пример:"
echo "  useradd -m -s /bin/bash alice"
echo "  passwd alice"
