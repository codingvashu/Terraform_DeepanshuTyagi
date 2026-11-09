#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y python3 python3-pip

mkdir -p /opt/terraform-app/backend

echo '${backend_app_b64}' | base64 -d > /opt/terraform-app/backend/app.py
echo '${backend_reqs_b64}' | base64 -d > /opt/terraform-app/backend/requirements.txt

python3 -m venv /opt/terraform-app/backend/venv
/opt/terraform-app/backend/venv/bin/pip install --upgrade pip
/opt/terraform-app/backend/venv/bin/pip install -r /opt/terraform-app/backend/requirements.txt

cat > /etc/systemd/system/flask-app.service <<'SERVICE'
[Unit]
Description=Flask Backend
After=network.target

[Service]
WorkingDirectory=/opt/terraform-app/backend
ExecStart=/opt/terraform-app/backend/venv/bin/python /opt/terraform-app/backend/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now flask-app
