#!/bin/bash
cd "$(dirname "$0")/backend"
source venv/bin/activate

# Get IP address
IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

echo "🚀 Запуск Backend сервера"
echo "   Локальный доступ: http://localhost:8000"
echo "   Сетевой доступ: http://${IP}:8000"
echo "   API документация: http://${IP}:8000/docs"
echo ""
uvicorn main:app --reload --host 0.0.0.0 --port 8000


