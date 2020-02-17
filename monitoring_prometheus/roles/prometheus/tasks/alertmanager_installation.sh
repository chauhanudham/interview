#!/bin/bash
# Make alermanager user
sudo useradd --no-create-home --shell /bin/false alertmanager

# Download node_exporter and copy utilities to where they should be in the filesystem
#VERSION=0.19.0
VERSION=$(curl https://raw.githubusercontent.com/prometheus/alertmanager/master/VERSION)
wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-amd64.tar.gz
tar xvzf alertmanager-${VERSION}.linux-amd64.tar.gz

sudo cp alertmanager-${VERSION}.linux-amd64/alertmanager /usr/local/bin/
sudo cp alertmanager-${VERSION}.linux-amd64/amtool /usr/local/bin/

sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

# Configure alertmanager
sudo mkdir /etc/alertmanager

# Main confirugation file
cat <<EOT > /etc/alertmanager/alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: [alertname]
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: email-coe
receivers:
- name: email-coe
  email_configs:
  - to: chauhanudham07@gmail.com
    from: @gmail.com
    smarthost: smtp.gmail.com:587
    auth_username: "chauhanudham@gmail.com"
    auth_identity: "chauhanudham@gmail.com"
    auth_password: "XXXXXXX"
EOT

# Alert YAML file
mkdir -p /etc/prometheus
touch /etc/prometheus/alert_rules.yml
cat <<EOT > /etc/prometheus/alert_rules.yml
groups:
 - name: example
   rules:
   - alert: InstanceDown
     expr: up == 0
     for: 1m
EOT

# Set right permission
sudo chown alertmanager:alertmanager -R /etc/alertmanager

# systemd
mkdir -p /etc/systemd/system
touch /etc/systemd/system/alertmanager.service
cat <<EOT > /etc/systemd/system/alertmanager.service
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
WorkingDirectory=/etc/alertmanager/
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --web.external-url http://0.0.0.0:9093

[Install]
WantedBy=multi-user.target
EOT

sudo chown -R prometheus:prometheus /etc/prometheus
# Enable and Start service 
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager
sudo systemctl restart prometheus


