sudo apt-get update
sudo apt-get upgrade -y

# SSH
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl enable ssh

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

# TODO:
# 1. Install ZSH plugins
# 2. Install ZSH theme