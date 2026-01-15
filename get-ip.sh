#!/bin/bash
echo "Finding your IP address..."
IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')

if [ -z "$IP" ]; then
    echo "❌ Could not determine IP address"
    echo "Please find your IP address manually:"
    echo "  macOS: ifconfig | grep 'inet '"
    echo "  Linux: hostname -I"
    echo "  Windows: ipconfig"
else
    echo "✅ Your IP address is: $IP"
    echo ""
    echo "Access URLs:"
    echo "  Frontend: http://$IP:5173"
    echo "  Backend:  http://$IP:8000"
    echo "  API Docs: http://$IP:8000/docs"
    echo ""
    echo "To configure frontend for network access, create frontend/.env:"
    echo "  VITE_API_URL=http://$IP:8000"
fi
