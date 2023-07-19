#!/bin/bash

# Get user input
read -p "Enter port to proxy to -> " port
read -p "Enter the domain / subdomain to accept requests from -> " domain
read -p "Enter your email for SSL installation -> " email

# system default
sudo apt update -y
sudo apt upgrade -y

# install docker
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt update -y
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y

# install nginx
sudo apt-get remove --purge nginx nginx-full nginx-common -y
sudo apt install nginx -y
printf "server {\n  listen 80 default_server;  \nlisten [::]:80 default_server;\n  server_name $domain;\n  location / {\n    proxy_pass http://localhost:$port;\n    proxy_http_version 1.1;\n    proxy_set_header Upgrade \$http_upgrade;\n    proxy_set_header Connection 'upgrade';\n    proxy_set_header Host \$host;\n    proxy_cache_bypass \$http_upgrade;\n  }\n}" > /etc/nginx/sites-available/default
nginx -t
sudo service nginx restart

# setup firewall for ssh, http & https
sudo ufw enable -y
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# setup python3 certbot
sudo apt install python3-acme python3-certbot python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface -y
sudo apt install python3-certbot-nginx -y
printf "$email\nA\nN\n2" | sudo certbot --nginx -d $domain