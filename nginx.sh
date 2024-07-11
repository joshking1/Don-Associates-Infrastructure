#!/bin/bash

# Update package list
sudo apt update -y

# Install Nginx
sudo apt install nginx -y

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Start Nginx service
sudo systemctl start nginx

# Check Nginx status
sudo systemctl status nginx

# Print Nginx version
nginx -v

echo "Nginx installation completed successfully."
