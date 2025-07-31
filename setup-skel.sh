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
: > "$AUTH_KEYS"  # то же, что touch, но чуть яснее по намерению

# 3. Устанавливаем правильные права
chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS"

# 4. Меняем владельца на root (важно для /etc/skel)
chown -R root:root "$SKEL_DIR"
echo "✅ Права установлены: .ssh/ — 700, authorized_keys — 600"

# 5. Проверяем, что useradd создаёт домашние каталоги по умолчанию
USERADD_CONFIG="/etc/default/useradd"
if [ -f "$USERADD_CONFIG" ]; then
    if grep -q "^CREATE_HOME=yes" "$USERADD_CONFIG"; then
        echo "✅ useradd настроен на автоматическое создание домашних каталогов."
    else
        echo "⚠️ Внимание: CREATE_HOME не включён в $USERADD_CONFIG. Добавьте: CREATE_HOME=yes"
    fi
else
    echo "⚠️ Файл $USERADD_CONFIG не найден. Убедитесь, что useradd настроен на копирование skel."
fi

# 6. Информационное сообщение
echo ""
echo "✨ Готово! Теперь при создании пользователя с флагом -m:"
echo "     useradd -m -s /bin/bash username"
echo "в домашнем каталоге будет создано:"
echo "     ~/.ssh/authorized_keys (пустой, нужно добавить ключи вручную)"
echo ""
echo "📌 Пример: добавление SSH-ключа для пользователя alice"
echo "     su - alice"
echo "     echo 'ssh-rsa AAA... user@host' >> ~/.ssh/authorized_keys"
echo "     chmod 600 ~/.ssh/authorized_keys"
echo "     chmod 700 ~/.ssh"
echo ""
echo "🔐 Важно: файл authorized_keys по умолчанию пуст — SSH-доступ без добавления ключа невозможен."
echo "   Это безопасно, но требует ручного добавления публичных ключей."
