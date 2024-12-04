#!/bin/bash

# Переменные
REPO_URL="https://github.com/PhosFactum/my-cfgs"
CFG_DIR="$HOME/.my-cfgs"
BIN_DIR="$HOME/.bin"
CONFIG_DIR="$HOME/.config"
BYEDPI_REPO="https://github.com/hufrea/byedpi"
XDG_CONFIG="$CFG_DIR/System/user-dirs.dirs"
DOWNLOAD_DIR="$HOME/Downloads"

# Новые пути для XDG-директорий
declare -A XDG_PATHS=(
    ["DESKTOP"]="$HOME/.Others/Desktop"
    ["DOWNLOAD"]="$HOME/Downloads"
    ["TEMPLATES"]="$HOME/.Others/Templates"
    ["PUBLICSHARE"]="$HOME/.Others/Public"
    ["DOCUMENTS"]="$HOME/.Others/Documents"
    ["MUSIC"]="$HOME/.Media/Music"
    ["PICTURES"]="$HOME/.Media/Pictures"
    ["VIDEOS"]="$HOME/.Media/Videos"
)

# Функция для создания директорий
create_directories() {
    for dir in "${XDG_PATHS[@]}"; do
        echo "Создаём директорию $dir..."
        mkdir -p "$dir"
    done
}

# Удаление старых русифицированных директорий XDG
for old_dir in "$HOME/Рабочий стол" "$HOME/Загрузки" "$HOME/Шаблоны" "$HOME/Документы" "$HOME/Видео" "$HOME/Изображения" "$HOME/Общедоступные" "$HOME/Музыка"; do
    if [ -d "$old_dir" ]; then
        echo "Удаляем старую директорию $old_dir..."
        rm -rf "$old_dir"
    fi
done

# 1. Обновление системы
echo "Обновляем систему..."
sudo pacman -Sy --noconfirm  # Обновление базы пакетов менеджера
sudo pacman -Syu --noconfirm  # Обновление всей системы

# 2. Установка необходимых пакетов
echo "Устанавливаем необходимые пакеты..."
sudo pacman -S --noconfirm --needed fakeroot base-devel vim yay git zsh bat tmux gdb telegram-desktop xclip

# Проверка на установку каждого пакета
if ! command -v fakeroot &>/dev/null; then
    echo "Ошибка при установке fakeroot."
fi

if ! command -v vim &>/dev/null; then
    echo "Ошибка при установке vim."
fi

if ! command -v yay &>/dev/null; then
    echo "Ошибка при установке yay."
fi

if ! command -v git &>/dev/null; then
    echo "Ошибка при установке git."
fi

if ! command -v zsh &>/dev/null; then
    echo "Ошибка при установке zsh."
fi

if ! command -v bat &>/dev/null; then
    echo "Ошибка при установке bat."
fi

if ! command -v tmux &>/dev/null; then
    echo "Ошибка при установке tmux."
fi

if ! command -v gdb &>/dev/null; then
    echo "Ошибка при установке gdb."
fi

if ! command -v telegram-desktop &>/dev/null; then
    echo "Ошибка при установке telegram-desktop."
fi

if ! command -v xclip &>/dev/null; then
    echo "Ошибка при установке xclip."
fi

# 3. Установка zathura через yay
echo "Устанавливаем zathura через yay..."
yay -S --noconfirm zathura

# 4. Создание XDG-директорий
echo "Создаём XDG-директории..."
create_directories

# Подключение пользовательского user-dirs.dirs
if [ -f "$XDG_CONFIG" ]; then
    echo "Создаём символическую ссылку на user-dirs.dirs..."
    mkdir -p "$HOME/.config"
    ln -sf "$XDG_CONFIG" "$HOME/.config/user-dirs.dirs"
else
    echo "Файл user-dirs.dirs не найден в репозитории!"
fi

# 5. Клонирование репозитория конфигураций
if [ ! -d "$CFG_DIR" ]; then
    echo "Клонируем репозиторий конфигураций..."
    git clone "$REPO_URL" "$CFG_DIR"
else
    echo "Репозиторий конфигураций уже клонирован."
fi

# 6. Создание символических ссылок для конфигов
echo "Создаём символические ссылки для конфигурационных файлов..."
ln -sf "$CFG_DIR/Shell/.bashrc" "$HOME/.bashrc"
ln -sf "$CFG_DIR/Shell/.zshrc" "$HOME/.zshrc"
sudo ln -sf "$CFG_DIR/Keyboard/gnome.cfg" "/etc/gnome.cfg"
sudo ln -sf "$CFG_DIR/Keyboard/kbct.yaml" "/etc/kbct.yaml"

# 7. Создание ссылок на скрипты в .bin
echo "Создаём символические ссылки для скриптов из Shell/bin..."
for script in "$CFG_DIR/Shell/bin/"*; do
    [ -f "$script" ] && ln -sf "$script" "$BIN_DIR/$(basename "$script")"
done

# 8. Создание ссылок на директории для nvim и tvim
echo "Создаём символические ссылки для nvim и tvim..."
cp -r "$CFG_DIR/Editor/nvim" "$CONFIG_DIR/nvim"
if [ -e "$CONFIG_DIR/tvim" ]; then
    echo "Удаляем существующий файл или ссылку: $CONFIG_DIR/Editor/tvim/tvim"
    rm -rf "$CONFIG_DIR/Editor/tvim/tvim"
fi
cp -r "$CFG_DIR/Editor/tvim" "$CONFIG_DIR/tvim"

# 9. Настройка клавиатуры (kbct)
echo "Настраиваем клавиатуру (kbct)..."

sudo systemctl stop kbct.service || true
sudo systemctl disable kbct.service || true
sudo systemctl unmask kbct.service || true
sudo rm -f /etc/systemd/system/kbct.service

echo "Копируем пользовательский kbct.service..."
sudo cp "$CFG_DIR/Keyboard/kbct.service" /etc/systemd/system/kbct.service

echo "Копируем конфигурацию kbct.yaml..."
sudo cp "~/.my-cfgs/Keyboard/kbct.yaml" /etc/kbct.yaml

echo "Активируем kbct.service..."
sudo systemctl daemon-reload
sudo systemctl enable kbct.service
sudo systemctl start kbct.service

echo "Настройка kbct завершена."

# 10. Установка и настройка byedpi
echo "Устанавливаем byedpi..."
BYEDPI_LATEST=$(curl -sL "$BYEDPI_REPO/releases/latest" | grep -oP 'href="\K.*?byedpi.*?linux.*?tar.gz(?=")')
BYEDPI_URL="https://github.com${BYEDPI_LATEST}"
curl -L -o /tmp/byedpi.tar.gz "$BYEDPI_URL"
sudo tar -xzf /tmp/byedpi.tar.gz -C /usr/local/bin
sudo chmod +x /usr/local/bin/byedpi
sudo ln -sf /usr/local/bin/byedpi /usr/bin/byedpi

# Перемещаем демон byedpi.service
echo "Перемещаем byedpi.service..."
sudo ln -sf "$CFG_DIR/Utilities/byedpi/byedpi.service" /etc/systemd/system/byedpi.service
sudo systemctl daemon-reload
sudo systemctl enable byedpi.service
sudo systemctl start byedpi.service

# Завершение
echo "Для создания шортката для переключения тачпада в GNOME, введите следующую команду в настройках клавиатуры (в разделе 'Горячие клавиши' -> 'Добавить'):"
echo "$HOME/.bin/toggle-touchpad"

# Удаляем директорию my-cfgs
echo "Удаляем директорию $HOME/my-cfgs..."
rm -rf "$HOME/my-cfgs"

# Инструкция для установки AdGuard VPN CLI
echo "Если вам нужно установить AdGuard VPN CLI, введите следующие команды:"
echo "1. curl -L -o \$HOME/Downloads/adguardvpn-cli.tar.gz 'https://github.com<ADGUARD_URL>'"
echo "2. tar -xzf \$HOME/Downloads/adguardvpn-cli.tar.gz -C \$HOME/Downloads"
echo "3. sudo mv \$HOME/Downloads/adguardvpn-cli /usr/local/bin/"

