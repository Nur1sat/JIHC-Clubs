# Quick Start - Network Access

## Your IP Address
Your computer's IP address is: **192.168.1.36**

## Starting the Application

### Option 1: Using Start Scripts (Recommended)

**Terminal 1 - Backend:**
```bash
./start-backend.sh
```

**Terminal 2 - Frontend:**
```bash
./start-frontend.sh
```

### Option 2: Manual Start

**Backend:**
```bash
cd backend
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Frontend:**
```bash
cd frontend
npm run dev
```

## Access URLs

### From This Computer:
- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

### From Other Devices on Same Network:
- Frontend: http://192.168.1.36:5173
- Backend API: http://192.168.1.36:8000
- API Docs: http://192.168.1.36:8000/docs

## Important Notes

1. **Firewall**: Make sure your firewall allows connections on ports 8000 and 5173
2. **Same Network**: All devices must be on the same Wi-Fi/LAN network
3. **IP Address**: Your IP may change if you reconnect to the network. Check with:
   ```bash
   ipconfig getifaddr en0  # macOS Wi-Fi
   ```

## Troubleshooting

If other devices can't connect:
1. Check firewall settings
2. Verify both servers are running
3. Confirm all devices are on the same network
4. Try accessing from a browser on the same computer first
