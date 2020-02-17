#!/bin/bash
#Change grafana default password
curl -X PUT -H "Content-Type: application/json" -d '{
  "oldPassword": "admin",
  "newPassword": "admin@123",
  "confirmNew": "admin@123"
}' http://admin:admin@localhost:3000/api/user/password

#After all deployment restart all services
sudo systemctl restart grafana-server
sudo systemctl restart prometheus

