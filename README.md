# OmniRoute + Hermes Setup

Этот проект содержит автоматический установщик для локального AI-шлюза **OmniRoute** и агента **Hermes**.

## Что внутри

- **OmniRoute**: Локальный прокси для 160+ AI-провайдеров. Позволяет объединить бесплатные аккаунты (Kiro AI, Qwen, GitHub Copilot) в один API.
- **Hermes Agent**: Мультиплатформенный AI-агент (Telegram, Discord, etc.), работающий через OmniRoute.
- **PM2**: Менеджер процессов для обеспечения работы шлюза 24/7.

## Быстрый старт

1. Убедитесь, что у вас установлен **Bun** (https://bun.sh).
2. Запустите установщик:

```bash
chmod +x install.sh
./install.sh
```

3. Во время установки введите пароль для доступа к дашборду.
4. Откройте `http://localhost:12800` и настройте провайдеров.

## Управление

- `pm2 status` — проверить работу OmniRoute.
- `pm2 logs omniroute` — посмотреть логи шлюза.
- `pm2 restart omniroute` — перезагрузить шлюз.

## Полезные ссылки

- [OmniRoute Dashboard](http://localhost:12800)
- [Kiro AI (Claude 4.5 Free)](https://aws.amazon.com/free/) — через AWS Builder ID.
