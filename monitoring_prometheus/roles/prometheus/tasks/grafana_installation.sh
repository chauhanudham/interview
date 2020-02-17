#!/bin/bash

# Download grafana
yum install -y  https://dl.grafana.com/oss/release/grafana-6.3.3-1.x86_64.rpm

#copy DB file
#sudo cp grafana.db /var/lib/grafana
sudo chown grafana:grafana /var/lib/grafana/grafana.db 
# systemd
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server


