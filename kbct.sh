#!/bin/bash

# 9. Настройка клавиатуры (kbct)
echo "Настраиваем клавиатуру (kbct)..."

# Остановка и удаление старых сервисов
sudo systemctl stop kbct.service || true
sudo systemctl disable kbct.service || true
sudo systemctl unmask kbct.service || true
sudo rm -f /etc/systemd/system/kbct.service

# Копируем пользовательский kbct.service
echo "Копируем пользовательский kbct.service..."
sudo cp "$HOME/.my-cfgs/Keyboard/kbct.service" /etc/systemd/system/kbct.service

# Копируем конфигурацию kbct.yaml
echo "Копируем конфигурацию kbct.yaml..."
sudo cp "$HOME/.my-cfgs/Keyboard/kbct.yaml" /etc/kbct.yaml

# Активируем kbct.service
echo "Активируем kbct.service..."
sudo systemctl daemon-reload
sudo systemctl enable kbct.service
sudo systemctl start kbct.service

echo "Настройка kbct завершена."
