#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y nodejs npm

mkdir -p /opt/terraform-app/frontend

echo '${frontend_app_b64}' | base64 -d > /opt/terraform-app/frontend/server.js
echo '${frontend_pkg_b64}' | base64 -d > /opt/terraform-app/frontend/package.json

cd /opt/terraform-app/frontend
npm install

cat > /etc/systemd/system/express-app.service <<'SERVICE'
[Unit]
Description=Express Frontend
After=network.target

[Service]
WorkingDirectory=/opt/terraform-app/frontend
Environment=PORT=3000
Environment=BACKEND_URL=http://${backend_ip}:5000
ExecStart=/usr/bin/node /opt/terraform-app/frontend/server.js
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now express-app
