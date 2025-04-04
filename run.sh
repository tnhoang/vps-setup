#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

# SSH
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl enable ssh

# Install and configure fail2ban
sudo apt install fail2ban -y

# Create fail2ban configuration
sudo mkdir -p /etc/fail2ban
sudo cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
# Ban hosts for 1 hour by default
bantime = 3600
# Check for SSH login attempts every 10 minutes
findtime = 600
# Ban after 5 failed login attempts
maxretry = 5

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
# Ban for 24 hours (in seconds)
bantime = 86400
EOF

# Restart fail2ban service to apply new configuration
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# Set up automatic permanent banning
chmod +x ban-persistent-attackers.sh
sudo cp ban-persistent-attackers.sh /usr/local/bin/

# Create a cron job to run the ban script daily
(crontab -l 2>/dev/null || echo "") | grep -v "ban-persistent-attackers.sh" | { cat; echo "0 0 * * * /usr/local/bin/ban-persistent-attackers.sh > /var/log/ban-persistent-attackers.log 2>&1"; } | crontab -

# Install dependencies for iptables persistence
sudo apt install iptables-persistent -y

# ZSH
sudo apt install zsh -y

sudo ufw disable

sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

sudo ufw enable

./edit-sshd.sh

sudo systemctl daemon-reload
sudo systemctl restart ssh

# Set up Docker aliases
mkdir -p ~/alias
cp docker_aliases.sh ~/alias/
echo 'source ~/alias/docker_aliases.sh' >> ~/.bashrc

# TODO:: https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df
# 1. Install ZSH plugins
# 2. Install ZSH theme