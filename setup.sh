#!/bin/bash

# Переменные
REPO_URL="https://github.com/PhosFactum/my-cfgs"
CFG_DIR="$HOME/.my-cfgs"
BIN_DIR="$HOME/.bin"
CONFIG_DIR="$HOME/.config"
BYEDPI_REPO="https://github.com/hufrea/byedpi"
XDG_CONFIG="$CFG_DIR/System/user-dirs.dirs"

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

# 1. Обновление системы
echo "Обновляем систему..."
sudo pacman -Syu --noconfirm

# 2. Создание XDG-директорий
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

# 3. Установка необходимых пакетов
echo "Устанавливаем базовые пакеты..."
sudo pacman -S --noconfirm --needed base-devel git vim zsh libreoffice-fresh-ru zathura bat tmux gdb telegram-desktop

# 4. Создание директории для пользовательских скриптов
echo "Создаём директорию для пользовательских скриптов..."
mkdir -p "$BIN_DIR"

# 5. Настройка git
echo "Настраиваем git..."
git config --global user.name "Phosphorus"
git config --global user.email "phosphorus.work@gmail.com"

# 6. Клонирование репозитория конфигураций
if [ ! -d "$CFG_DIR" ]; then
    echo "Клонируем репозиторий конфигураций..."
    git clone "$REPO_URL" "$CFG_DIR"
else
    echo "Репозиторий конфигураций уже клонирован."
fi

# 7. Создание символических ссылок для конфигов
echo "Создаём символические ссылки для конфигурационных файлов..."
ln -sf "$CFG_DIR/Shell/.bashrc" "$HOME/.bashrc"
ln -sf "$CFG_DIR/Shell/.zshrc" "$HOME/.zshrc"
sudo ln -sf "$CFG_DIR/Keyboard/gnome.cfg" "/etc/gnome.cfg"
sudo ln -sf "$CFG_DIR/Keyboard/kbct.yaml" "/etc/kbct.yaml"

# 8. Создание ссылок на скрипты в .bin
echo "Создаём символические ссылки для скриптов из Shell/bin..."
for script in "$CFG_DIR/Shell/bin/"*; do
    [ -f "$script" ] && ln -sf "$script" "$BIN_DIR/$(basename "$script")"
done

# 9. Создание ссылок на директории для nvim и tvim
echo "Создаём символические ссылки для nvim и tvim..."
ln -sf "$CFG_DIR/Editor/nvim" "$CONFIG_DIR/nvim"
if [ -e "$CONFIG_DIR/tvim" ]; then
    echo "Удаляем существующий файл или ссылку: $CONFIG_DIR/tvim"
    rm -rf "$CONFIG_DIR/tvim"
fi
ln -sf "$CFG_DIR/Editor/tvim" "$CONFIG_DIR/tvim"

# 10. Установка YAY
if ! command -v yay &>/dev/null; then
    echo "Устанавливаем YAY..."
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "YAY уже установлен."
fi

# 11. Установка дополнительных пакетов через YAY
echo "Устанавливаем пакеты через YAY..."
yay -S --noconfirm kbct keepass

# 12. Настройка клавиатуры (kbct)
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

# 13. Установка AdGuard VPN CLI
echo "Устанавливаем AdGuard VPN CLI..."
DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"
ADGUARD_URL=$(curl -sL "https://github.com/AdguardTeam/AdGuardVPNCLI/releases/latest" | grep -oP 'href="\K.*adguardvpn-cli.*?linux.*?tar.gz(?=")')
curl -L -o "$DOWNLOAD_DIR/adguardvpn-cli.tar.gz" "https://github.com${ADGUARD_URL}"
tar -xzf "$DOWNLOAD_DIR/adguardvpn-cli.tar.gz" -C "$DOWNLOAD_DIR"
sudo mv "$DOWNLOAD_DIR/adguardvpn-cli" /usr/local/bin/
gpg --keyserver 'keys.openpgp.org' --recv-key '28645AC9776EC4C00BCE2AFC0FE641E7235E2EC6'
gpg --verify "$DOWNLOAD_DIR/adguardvpn-cli.sig"

# 14. Установка и настройка byedpi
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
echo "Установка завершена! Не забудьте вручную создать ярлык для переключения раскладки в GNOME."
