# Deleting directory
rm -rf /opt/dnschef

# Install service
rm /etc/systemd/system/dnschef.service

# Enable and start service
systemctl daemon-reload
systemctl stop dnschef.service
systemctl disable dnschef.service
