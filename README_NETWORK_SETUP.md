# Network Access Setup Guide

This guide explains how to run the application so it can be accessed from other devices on the network.

## Prerequisites

1. Make sure both backend and frontend are running
2. Find your computer's IP address (see instructions below)
3. Ensure your firewall allows connections on ports 8000 (backend) and 5173 (frontend)

## Finding Your IP Address

### macOS/Linux:
```bash
# Option 1: Get IP address
ifconfig | grep "inet " | grep -v 127.0.0.1

# Option 2: Get IP address (alternative)
ipconfig getifaddr en0  # For Wi-Fi
ipconfig getifaddr en1  # For Ethernet
```

### Windows:
```cmd
ipconfig
# Look for "IPv4 Address" under your active network adapter
```

## Running the Application

### Backend (Port 8000)

The backend is already configured to accept connections from any IP address (0.0.0.0).

```bash
cd backend
source venv/bin/activate  # On Windows: venv\Scripts\activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend (Port 5173)

The frontend is configured to accept connections from any IP address.

```bash
cd frontend
npm run dev
```

The frontend will be accessible at:
- `http://localhost:5173` (local)
- `http://YOUR_IP_ADDRESS:5173` (from other devices)

## Accessing from Other Devices

1. **Find your computer's IP address** (see above)
2. **On another device** (phone, tablet, another computer):
   - Connect to the same network (Wi-Fi or LAN)
   - Open a web browser
   - Navigate to: `http://YOUR_IP_ADDRESS:5173`
   - Example: `http://192.168.1.100:5173`

## Configuration

### Backend API URL

**For Local Development (Default):**
- No configuration needed. The frontend uses a proxy to connect to the backend.

**For Network Access from Other Devices:**
Create a `.env` file in the `frontend` directory:

```env
VITE_API_URL=http://YOUR_IP_ADDRESS:8000
```

Example:
```env
VITE_API_URL=http://192.168.1.36:8000
```

Then restart the frontend dev server. This tells the frontend to connect directly to the backend IP address instead of using the proxy.

**Note:** When accessing from other devices, you MUST set `VITE_API_URL` to your backend IP address, otherwise API calls will fail.

### CORS Configuration

The backend is configured to allow requests from any origin. For production, you should restrict this in `backend/main.py`:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://yourdomain.com", "http://192.168.1.100:5173"],  # Specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Troubleshooting

### Cannot connect from other devices

1. **Check firewall**: Make sure ports 8000 and 5173 are open
   - macOS: System Preferences > Security & Privacy > Firewall
   - Windows: Windows Defender Firewall > Allow an app

2. **Check network**: Ensure all devices are on the same network

3. **Check IP address**: Verify you're using the correct IP address

4. **Check if servers are running**: Verify both backend and frontend are running

### CORS errors

If you see CORS errors, make sure:
- Backend CORS is configured to allow your frontend origin
- You're accessing the frontend using the IP address, not localhost

## Production Deployment

For production, consider:
- Using a reverse proxy (nginx, Apache)
- Setting up SSL/HTTPS
- Restricting CORS to specific domains
- Using environment variables for configuration
- Deploying to a cloud service (AWS, Heroku, etc.)
