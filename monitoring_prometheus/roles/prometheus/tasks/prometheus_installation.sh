#!/bin/bash

# Make prometheus user
sudo useradd -M -s /bin/false -c "Prometheus Monitoring User" prometheus

# Make directories and dummy files necessary for prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo touch /etc/prometheus/prometheus.yml
sudo touch /etc/prometheus/prometheus.rules.yml

# Assign ownership of the files above to prometheus user
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Download prometheus and copy utilities to where they should be in the filesystem
#VERSION=2.2.1
VERSION=$(curl https://raw.githubusercontent.com/prometheus/prometheus/master/VERSION)
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz
tar xvzf prometheus-${VERSION}.linux-amd64.tar.gz

echo "Copy configuration files"
sudo cp prometheus-${VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-${VERSION}.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-${VERSION}.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-${VERSION}.linux-amd64/console_libraries /etc/prometheus

echo "Assign the ownership of the tools above to prometheus user"
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Populate configuration files
cat ./prometheus-${VERSION}.linux-amd64/prometheus.yml | sudo tee /etc/prometheus/prometheus.yml
#cat ./prometheus-${VERSION}.linux-amd64/prometheus.service | sudo tee /etc/systemd/system/prometheus.service

#Prometheus.yml configuration
rm -rf /etc/prometheus/prometheus.yml
cat <<EOT >> /etc/prometheus/prometheus.yml
global:
  scrape_interval: 1s
  evaluation_interval: 1s

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - "alert_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  - job_name: 'node_exporter_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'All_Running_Node'
    ec2_sd_configs:
      - region: us-east-1
        profile: ec2_ccess
        port: 9100
    relabel_configs:
        # Only monitor instances with a Name starting with "SD Demo"
      - source_labels: [__meta_ec2_tag_Name]
        regex: .*
        action: keep
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance_id
      - source_labels: [__meta_ec2_private_ip]
        target_label: instance
  - job_name: 'cadvisor'
    ec2_sd_configs:
      - region: us-east-1
        profile: ec2_ccess
        port: 9280
    relabel_configs:
        # Only monitor instances with a Name starting with "SD Demo"
      - source_labels: [__meta_ec2_tag_Node_agent]
        regex: cadvisor.*
        action: keep
        # Use the instance ID as the instance label
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance_id
      - source_labels: [__meta_ec2_private_ip]
        target_label: instance
EOT

sudo chown -R prometheus:prometheus /etc/prometheus
#prometheus.service configuration
cat <<EOT >> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
    --web.listen-address=127.0.0.1:9090

[Install]
WantedBy=multi-user.target
EOT

#Configure console access
cp /etc/prometheus/consoles/index.html.example /etc/prometheus/consoles/index.html

# systemd
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Installation cleanup
#rm prometheus-${VERSION}.linux-amd64.tar.gz
#rm -rf prometheus-${VERSION}.linux-amd64

# Nginx Installation and configuration
echo "Nginx Installation and configuration"
amazon-linux-extras install nginx1.12 -y
yum install httpd-tools -y
rm -rf /etc/nginx/nginx.conf

cat <<EOT >> /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

         auth_basic "Restricted";
         auth_basic_user_file /etc/nginx/.htpasswd;
        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
         proxy_pass http://localhost:9090;
        }

            location = /50x.html {
        }


        }
        }
EOT

# Create htaccess user
printf "feenixdv:$(openssl passwd -crypt admin@1)\n" >> /etc/nginx/.htpasswd

# Service start and enable
# systemd
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl start nginx

