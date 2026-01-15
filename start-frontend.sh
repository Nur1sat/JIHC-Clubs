#!/bin/bash
cd "$(dirname "$0")/frontend"

# Get IP address
IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

echo "🚀 Запуск Frontend сервера"
echo "   Локальный доступ: http://localhost:5173"
echo "   Сетевой доступ: http://${IP}:5173"
echo ""
npm run dev


