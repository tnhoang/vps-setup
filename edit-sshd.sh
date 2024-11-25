#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Define the sshd_config file path
config_file="/etc/ssh/sshd_config"

# Make a backup of the original file
cp "$config_file" "${config_file}.bak"

# Update the configuration
sed -i 's/^#*Port .*/Port 22/' "$config_file"
sed -i 's/^#*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/' "$config_file"
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' "$config_file"
sed -i 's/^#*UsePAM .*/UsePAM no/' "$config_file"
sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' "$config_file"

echo "SSH configuration updated successfully."
echo "Please restart the SSH service for changes to take effect."