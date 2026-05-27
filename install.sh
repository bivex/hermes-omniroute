#!/bin/bash

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}   OmniRoute + Hermes Auto-Installer       ${NC}"
echo -e "${BLUE}===========================================${NC}"

# --- Check Dependencies ---
echo -e "\n${YELLOW}[1/5] Проверка зависимостей...${NC}"

if ! command -v bun &> /dev/null; then
    echo -e "${RED}Ошибка: Bun не установлен. Установите Bun (https://bun.sh)${NC}"
    exit 1
fi

echo -e "${GREEN}✔ Bun $(bun -v) обнаружен${NC}"

# --- Install OmniRoute & PM2 ---
echo -e "\n${YELLOW}[2/5] Установка OmniRoute и PM2 через Bun...${NC}"

echo -e "Выполнение: bun install -g omniroute pm2"
bun install -g omniroute pm2

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ OmniRoute и PM2 успешно установлены${NC}"
else
    echo -e "${RED}Ошибка при установке пакетов через bun.${NC}"
    exit 1
fi

# --- Setup Environment ---
echo -e "\n${YELLOW}[3/5] Настройка безопасности...${NC}"

# Ask for password if not set
if [ -z "$INITIAL_PASSWORD" ]; then
    read -sp "Введите начальный пароль для OmniRoute Dashboard: " PASS
    echo ""
    export INITIAL_PASSWORD=$PASS
fi

echo -e "${GREEN}✔ Пароль установлен${NC}"

# --- Launch OmniRoute ---
echo -e "\n${YELLOW}[4/5] Запуск OmniRoute в фоновом режиме...${NC}"

# Check if already running in PM2
pm2 stop omniroute &> /dev/null
pm2 delete omniroute &> /dev/null

pm2 start omniroute --name "omniroute" --env INITIAL_PASSWORD="$INITIAL_PASSWORD"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ OmniRoute запущен на http://localhost:12800${NC}"
    pm2 save
else
    echo -e "${RED}Ошибка при запуске OmniRoute через PM2.${NC}"
    exit 1
fi

# --- Hermes Agent Setup (Optional) ---
echo -e "\n${YELLOW}[5/5] Подготовка Hermes Agent...${NC}"
echo -e "Создание директории для агента..."
mkdir -p hermes-agent
cd hermes-agent

# Здесь можно добавить клонирование репозитория Hermes, если есть URL
# git clone https://github.com/noes-research/hermes.git .

echo -e "${BLUE}-------------------------------------------${NC}"
echo -e "${GREEN}Установка завершена!${NC}"
echo -e "\n${YELLOW}Следующие шаги:${NC}"
echo -e "1. Откройте Dashboard: ${BLUE}http://localhost:12800${NC}"
echo -e "2. Войдите с вашим паролем."
echo -e "3. Добавьте провайдеров (Kiro AI, Qwen, etc.)"
echo -e "4. Создайте API Key в разделе API Manager."
echo -e "5. Используйте этот ключ в Hermes или других агентах."
echo -e "\n${YELLOW}Управление процессом:${NC}"
echo -e "- Логи: ${BLUE}pm2 logs omniroute${NC}"
echo -e "- Перезапуск: ${BLUE}pm2 restart omniroute${NC}"
echo -e "- Статус: ${BLUE}pm2 status${NC}"
echo -e "${BLUE}-------------------------------------------${NC}"
