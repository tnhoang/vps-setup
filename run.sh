sudo apt-get update
sudo apt-get upgrade -y

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
mv docker_aliases.sh ~/alias/
echo 'source ~/alias/docker_aliases.sh' >> ~/.bashrc