#!/bin/bash
set -e
sudo sed -i "s|server 127.0.0.1:[0-9]*|server 127.0.0.1:3001|" /etc/nginx/sites-available/app.conf
sudo sed -i "s|frontend-[a-z]*|frontend-blue|" /etc/nginx/sites-available/app.conf
sudo nginx -t && sudo systemctl reload nginx
echo "Rollback a blue"