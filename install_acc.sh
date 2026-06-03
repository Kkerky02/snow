#!/bin/bash
# ==============================================================================
# ServiceNow Agent Client Collector (ACC) - Automated Silent Install (RHEL)
# ==============================================================================

# Configure your MID Server URL and API Key here
MID_SERVER_URL="wss://10.0.0.4:8043/ws/events"
API_KEY="wNykxwXdCeZTG88C8b3DHXDVEfXynjZ3"

# Default file names and paths
RPM_FILE="agent-client-collector.rpm"
CONFIG_FILE="/etc/servicenow/agent-client-collector/acc.yml"

echo "======================================================="
echo "  Starting ServiceNow ACC Automated Installation..."
echo "======================================================="

# 0. Root privilege check
if [ "$EUID" -ne 0 ]; then
  echo "[Error] Please run as root using sudo"
  exit 1
fi

# 1. Check if RPM file exists
if [ ! -f "$RPM_FILE" ]; then
  echo "[Error] RPM file $RPM_FILE not found in current directory"
  exit 1
fi

# 2. Install RPM package
echo ">>> [1/4] Installing RPM package..."
rpm -ivh "$RPM_FILE"

# 3. Inject MID Server URL and API Key
echo ">>> [2/4] Injecting MID Server URL and API Key..."
sed -i "s|\"wss://127.0.0.1:8800/ws/events\"|\"$MID_SERVER_URL\"|g" $CONFIG_FILE
sed -i "s|\"ws://127.0.0.1:80/ws/events\"|\"$MID_SERVER_URL\"|g" $CONFIG_FILE
sed -i "s|api-key: \"\"|api-key: \"$API_KEY\"|g" $CONFIG_FILE

# 4. Fix file permissions
echo ">>> [3/4] Fixing file permissions..."
chown servicenow:servicenow $CONFIG_FILE
chmod 640 $CONFIG_FILE

# 5. Start ACC service and enable on boot
echo ">>> [4/4] Starting ACC service..."
systemctl enable acc --now

echo "======================================================="
echo "  Installation Complete!"
echo "  Reading the latest logs..."
echo "======================================================="
sleep 3

# 6. Check the latest logs
tail -n 15 /var/log/servicenow/agent-client-collector/acc.log